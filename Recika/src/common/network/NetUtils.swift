//
//  NetUtils.swift
//  Recika
//
//  Created by liqc on 2018/10/24.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

typealias CallbackDynamic = (DynamicChainData?, String?) -> Void

func getUID(callback: @escaping Callback) {
    if let uid = UserDefaults.standard.object(forKey: UDKey.uid) as? String {
        return callback(uid)
    }
    
    guard var api = URLComponents(string: uidAPI) else {
        return callback(nil)
    }
    
    api.queryItems = [
        URLQueryItem(name: "name", value: userName)
    ]
    
    Alamofire.request(api, method: .get).responseJSON { response in
        if let error = response.error {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            return callback(nil)
        }
        
        guard let data = response.data else {
            SVProgressHUD.showError(withStatus: "fail to get data")
            return callback(nil)
        }
        
        let json = JSON(data)
        let uid = json["id"].stringValue
        UserDefaults.standard.set(uid, forKey: UDKey.uid)
        UserDefaults.standard.synchronize()
        return callback(uid)
    }
}

func getChainId(callback: @escaping Callback) {
    if let chainId = UserDefaults.standard.object(forKey: UDKey.chainID) as? String {
        return callback(chainId)
    }
    
    guard let api = URLComponents(string: chainIdAPI) else {
        return callback(nil)
    }
    
    Alamofire.request(api, method: .get).responseJSON { response in
        if let error = response.error {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            return callback(nil)
        }
        
        guard let data = response.data else {
            SVProgressHUD.showError(withStatus: "fail to get data")
            return callback(nil)
        }
        
        let json = JSON(data)
        let chainId = json["chain_id"].stringValue
        UserDefaults.standard.set(chainId, forKey: UDKey.chainID)
        UserDefaults.standard.synchronize()
        return callback(chainId)
    }
}

func getDynamicChainInfo(callback: @escaping CallbackDynamic) {
    guard let api = URLComponents(string: chainAPI) else {
        return callback(nil, "fail to get api")
    }
    
    Alamofire.request(api, method: .get).responseJSON { response in
        if let error = response.error {
            return callback(nil, error.localizedDescription)
        }
        
        guard let data = response.data else {
            return callback(nil, "fail to get response data.")
        }
        
        let json = JSON(data)
        
        let chainInfo = DynamicChainData(json: json)
        return callback(chainInfo, nil)
    }
}

func doTransfer(amount: Int, assetId: String, symbol: String, callback : @escaping Callback) {
    getChainId { chainId in
        guard let chainId = chainId else {
            return callback("fail to get chainId.")
        }
        
        getUID { uid in
            guard let uid = uid else {
                return callback("fail to get uid.")
            }
            
            getDynamicChainInfo { chainInfo, errorMsg in
                if let errorMsg = errorMsg {
                    return callback(errorMsg)
                }
                
                guard let chainInfo = chainInfo else {
                    return callback("can not found chain info.")
                }

                let headBlockNumber = chainInfo.headBlockNumber
                let headBlockId = chainInfo.headBlockId
                
                // asseet id?
                // receive_asset_id
                
                // do transfer.
                let expiration = Date().timeIntervalSince1970 + 10 * 3600
                
                // dummy
                let last_from_uid = getLastNum(from: uid)
                let last_to_uid = getLastNum(from: AdminUID)
                let last_asset_id = getLastNum(from: assetId)
                let fee_id = "1.3.0"
                let last_fee_id = getLastNum(from: fee_id)
                let fee_amount = Int64(1000)
                
                //  dummy. 需要弹出用户输入密码框.
                guard let keys = BitShareCoordinator.getUserKeys(userName, password: "123456") else {return}

                let keyJson = JSON(keys)
                let keysData = KeysData(keyJson)

                if [keysData.activeKey.publicKey, keysData.memoKey.publicKey, keysData.ownerKey.publicKey].contains(activePubKey) {
                    BitShareCoordinator.resetDefaultPublicKey(activePubKey)
                }

                // 通过C++库来进行签名. 然后再用websocket进行广播.
                let jsonstr = BitShareCoordinator.getTransaction(Int32(headBlockNumber), block_id: headBlockId, expiration: expiration, chain_id: chainId, from_user_id: last_from_uid, to_user_id: last_to_uid, asset_id: last_asset_id, receive_asset_id: last_asset_id, amount: Int64(amount), fee_id: last_fee_id, fee_amount: fee_amount, memo: "", from_memo_key: memoPubKey, to_memo_key: AdminMemoKey)
                
                guard let result = jsonstr else {
                    return callback("fail to signature.")
                }

                let paramJson = JSON(parseJSON: result)
                print(result)

                // broadcast to blockchain.
                guard let api = URLComponents(string: broadcastAPI) else {
                    return callback("fail to get api.")
                }
                
                let headers = ["Content-type": "application/json"]
                let params = ["transaction": result]
                Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    if let error = response.error {
                        return callback(error.localizedDescription)
                    }
                    
                    guard let data = response.data else {
                        return callback("data")
                    }
                    
                    let json = JSON(data)
                }
                
                return callback(nil)
            }
        }
    }
}

func doWalletTransfer(amount: Int, symbol: String, callback: @escaping Callback) {
    guard let keys = BitShareCoordinator.getUserKeys(userName, password: "123456") else {return}

    let privateKey = "5HvW2suJvX8RNntU3kAUfRopesHJ6ropvyoyqjJNEF5zpL3FSqk"    // dummy. 需要解析keys来获取private key.
    let publicKey = activePubKey
    let memo = ""
    
    guard let api = URLComponents(string: transferAPI) else {
        return callback("fail to get api.")
    }
    
    let headers = ["Content-type": "application/json"]
    let params: [String: Any] = [
        "from_name": userName,
        "to_name": AdminName,
        "amount": amount,
        "symbol": symbol,
        "private_key": privateKey,
        "public_key": publicKey,
        "memo": memo
    ]
    
    Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        if let error = response.error {
            return callback(error.localizedDescription)
        }
        
        guard let data = response.data else {
            return callback("fail to get response data.")
        }
        
        let json = JSON(data)
        return callback(nil)
    }
}

/*
 * App 本地签名.
 */
func doTransferLocal(amount: Int, assetId: String, symbol: String, callback : @escaping Callback) {
    getChainId { chainId in
        guard let chainId = chainId else {
            return callback("fail to get chainId.")
        }
        
        getUID { uid in
            guard let uid = uid else {
                return callback("fail to get uid.")
            }
            
            getDynamicChainInfo { chainInfo, errorMsg in
                if let errorMsg = errorMsg {
                    return callback(errorMsg)
                }
                
                guard let chainInfo = chainInfo else {
                    return callback("can not found chain info.")
                }

                let headBlockNumber = chainInfo.headBlockNumber
                let headBlockId = chainInfo.headBlockId
                
                // asseet id?
                // receive_asset_id
                
                // do transfer.
                let expiration = Date().timeIntervalSince1970 + 10 * 3600
                
                // dummy
                let last_from_uid = getLastNum(from: uid)
                let last_to_uid = getLastNum(from: AdminUID)
                let last_asset_id = getLastNum(from: assetId)
                let fee_id = "1.3.0"
                let last_fee_id = getLastNum(from: fee_id)
                let fee_amount = Int64(1000)
   
                //  dummy. 需要弹出用户输入密码框.
                guard let keys = BitShareCoordinator.getUserKeys(userName, password: "123456") else {return}
                
                let keyJson = JSON(keys)
                let keysData = KeysData(keyJson)

                if [keysData.activeKey.publicKey, keysData.memoKey.publicKey, keysData.ownerKey.publicKey].contains(activePubKey) {
                    BitShareCoordinator.resetDefaultPublicKey(activePubKey)
                }
                
                // 通过C++库来进行签名. 然后再用websocket进行广播.
                let jsonstr = BitShareCoordinator.getTransaction(Int32(headBlockNumber), block_id: headBlockId, expiration: expiration, chain_id: chainId, from_user_id: last_from_uid, to_user_id: last_to_uid, asset_id: last_asset_id, receive_asset_id: last_asset_id, amount: Int64(amount), fee_id: last_fee_id, fee_amount: fee_amount, memo: "", from_memo_key: memoPubKey, to_memo_key: AdminMemoKey)
                
                guard let result = jsonstr else {
                    return callback("fail to signature.")
                }
                
                if let json = JSON(result).dictionaryObject {
                    CybexSocket.shared.transfer(transaction: json, onSuccess: {
                        return callback(nil)
                    }, onFail: { msg in
                        return callback(msg)
                    })
                }
            }
        }
    }
}
