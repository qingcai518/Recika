//
//  LoginViewModel.swift
//  Recika
//
//  Created by liqc on 2018/08/28.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON

class LoginViewModel {
    func doLogin(name: String?, password: String?, completion: @escaping (String?) -> Void) {
        guard let name = name else {return completion("no user name")}
        guard let password = password else {return completion("no password")}
        
        guard let api = URLComponents(string: loginAPI) else {return completion("can not get api")}
        let params = [
            "name": name,
            "password": password
        ]
        
        let headers = [
            "Content-type": "application/json"
        ]
        
        SVProgressHUD.show()
        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion("can not get data")
            }
            
            let json = JSON(data)
            print(json)
            if let errorMsg = json["msg"].string {
                return completion(errorMsg)
            }
            
            let name = json["name"].stringValue
            let activeKey = json["active_pub_key"].stringValue
            let ownerKey = json["owner_pub_key"].stringValue
            let memoKey = json["memo_pub_key"].stringValue
            saveUser(name: name, ownerKey: ownerKey, activeKey: activeKey, memoKey: memoKey)
            return completion(nil)
        }
    }
}
