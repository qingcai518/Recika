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
        
        print(json)
        
        let chainInfo = DynamicChainData(json: json)
        return callback(chainInfo, nil)
    }
}

func doTransfer(amount: Int, assetId: String, callback : @escaping Callback) {
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
                
                print(chainInfo)
                
                let headBlockNumber = chainInfo.headBlockNumber
                let headBlockId = chainInfo.headBlockId
                
                print("chain id = \(chainId)")
                print("uid = \(uid)")
                print("head block number = \(headBlockNumber)")
                print("head block id = \(headBlockId)")
                
                // asseet id?
                // receive_asset_id
                
                
                // do transfer.
                let expiration = Date().timeIntervalSince1970 + 10 * 3600
                
                // dummy
                let last_from_uid = getLastNum(from: uid)
                let last_to_uid = getLastNum(from: AdminUID)
                let last_asset_id = getLastNum(from: assetId)
                
                let jsonstr = BitShareCoordinator.getTransaction(Int32(headBlockNumber), block_id: headBlockId, expiration: expiration, chain_id: chainId, from_user_id: last_from_uid, to_user_id: last_to_uid, asset_id: last_asset_id, receive_asset_id: last_asset_id, amount: Int64(amount), fee_id: last_asset_id, fee_amount: 100000, memo: "", from_memo_key: memoPubKey, to_memo_key: "")
                
                print(jsonstr)
                
                return callback(nil)
            }
        }
    }
}
