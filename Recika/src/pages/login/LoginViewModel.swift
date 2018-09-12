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
        guard let password = password else {return completion("")}
        
        let url = loginAPI + "?username=\(name)&password=\(password)"
        guard let api = URLComponents(string: url) else {return completion(nil)}
        
        SVProgressHUD.show()
        Alamofire.request(api, method: .get).responseJSON { response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion("can not get data")
            }
            
            let json = JSON(data)
            if json == JSON.null {
                return completion("fail to login.")
            }
            let name = json["Name"].stringValue
            let activeKey = json["ActivePubKey"].stringValue
            let ownerKey = json["OwnerPubKey"].stringValue
            let memoKey = json["MemoPubKey"].stringValue
            
            saveUser(name: name, ownerKey: ownerKey, activeKey: activeKey, memoKey: memoKey)
            return completion(nil)
        }
    }
}
