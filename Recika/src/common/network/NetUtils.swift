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

func doTransfer(callback : @escaping Callback) {
    getChainId { chainId in
        guard let chainId = chainId else {
            return callback("fail to get chainId.")
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
            
            print("head block number = \(headBlockNumber)")
            print("head block id = \(headBlockId)")
            
            // do transfer.
            let expiration = Date().timeIntervalSince1970 + 10 * 3600
            
            return callback(nil)
        }
    }
}
