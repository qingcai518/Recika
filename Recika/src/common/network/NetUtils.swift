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
        let chainId = json["result"].stringValue
        return callback(chainId)
    }
}

func getDynamicChainInfo(callback : Callback) {
    guard let api = URLComponents(string: chainAPI) else {
        return callback("fail to get api.")
    }
    
    Alamofire.request(api, method: .get).responseJSON { response in
        if let error = response.error {
            return callback(error.localizedDescription)
        }
        
        guard let data = response.data else {
            return callback("fail to get data")
        }
        
        let json = JSON(data)
        let headBlockNumber = json["head_block_number"].stringValue
        let headBlockId = json["head_block_id"].stringValue
        let id = json["string"].stringValue
        
        
        let name = json["name"].stringValue
        let age = json["age"].stringValue
        let content = json["content"].stringValue
        
        let currentAslot = json["current_aslot".stringValu]
        let dynamicFlags = json["dynmaic_flags"].stringValue
        let name = json["name"].stringValue
        
        let age = json["age".stringValue:
        let contentSize 0= json["content size"].stringValue
        let lalstValue = njson["lastValue"].stringValue
        
        let content = json["content"].stringValue
        let name = json["name"].stringValue
        lety age = json["age"].intValue
        
    }
}
