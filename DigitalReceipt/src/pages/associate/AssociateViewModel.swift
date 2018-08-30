
//
//  AssociateViewModel.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/30.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AssociateViewModel {
    func associate(name: String?, password: String?, completion: @escaping (String?) -> Void) {
        guard let name = name else {return completion("名前を指定してください")}
        guard let pw = password else {return completion("パスワードを指定してください")}
        
        let headers = ["Content-type": "application/json"]
        let params = ["name": name, "passowrd": pw]
        
        guard let api = URLComponents(string: associateAPI) else {return completion(nil)}
        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion("取得できませんでした。")
            }
            
            let json = JSON(data)
            print(json)
            let ownerKey = json["owner_key"].stringValue
            let activeKey = json["active_key"].stringValue
            let memoKey = json["memo_key"].stringValue
            
            saveUser(name: name, ownerKey: ownerKey, activeKey: activeKey, memoKey: memoKey)
            
            return completion(nil)
        }
    }
}
