//
//  SignupViewModel.swift
//  Recika
//
//  Created by liqc on 2018/08/23.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SignupViewModel {
    func doSignup(name: String?, password: String?, completion:@escaping (String?)-> Void) {
        guard let name = name else {return completion(nil)}
        guard let password = password else {return completion(nil)}
        guard let api = URLComponents(string: signupAPI) else {return completion(nil)}
        
        let params = [
            "name": name,
            "password": password
        ]
        
        let headers = ["Content-type": "application/json"]
        SVProgressHUD.show()
        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {return completion(nil)}
            let result = JSON(data)
            if let msg = result["msg"].string {
                return completion(msg)
            }
            
            // store user infos
            let options = result["operations"].arrayValue.first?.arrayValue.last
            let ownerPubKey = options?["owner", "key_auths"].arrayValue.first?.arrayValue.first?.stringValue
            let activePubKey = options?["active", "key_auths"].arrayValue.first?.arrayValue.first?.stringValue
            let memoPubKey = options?["memo_key"].stringValue
            
            saveUser(name: name, ownerKey: ownerPubKey, activeKey: activePubKey, memoKey: memoPubKey)
            return completion(nil)
        }
    }
}
