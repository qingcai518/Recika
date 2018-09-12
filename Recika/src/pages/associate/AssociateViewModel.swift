
//
//  AssociateViewModel.swift
//  Recika
//
//  Created by liqc on 2018/08/30.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AssociateViewModel {
    func associate(name: String?, password: String?, completion: @escaping (String?) -> Void) {
        guard let name = name else {return completion("名前を指定してください")}
        guard let password = password else {return completion("パスワードを指定してください")}
        
        let headers = ["Content-type": "application/json"]
        let params = ["name": name, "password": password]
        guard let api = URLComponents(string: associateAPI) else {return completion(nil)}
        
        print(api)
        print(params)
        print(headers)
        
        SVProgressHUD.show()
        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion("取得できませんでした。")
            }
            
            let json = JSON(data)
            let msg = json["msg"].stringValue
            if msg != "" {
                return completion(msg)
            }
            return completion(nil)
        }
    }
}
