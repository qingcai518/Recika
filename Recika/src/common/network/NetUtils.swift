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

func getDynamicChainInfo(callback: Callback) {
    guard let api = URLComponents(string: chainAPI) else {
        return callback("fail to get api")
    }
    
    Alamofire.request(api, method: .get).responseJSON { response in
        if let error = response.error {
            return callback("fail to get api.")
        }
        
        guard let data = response.data else {
            return callback("fail to get data")
        }
        
        let json = JSON(data)
        print(json)
        
        let chainInfo = DynamicChainData(json: json)
        return callback(chainInfo)
    }
}
