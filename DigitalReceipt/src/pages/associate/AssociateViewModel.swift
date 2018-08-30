
//
//  AssociateViewModel.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/30.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire

class AssociateViewModel {
    func associate(name: String?, password: String?, completion: @escaping (String?) -> Void) {
        guard let name = name else {return completion("名前を指定してください")}
        guard let pw = password else {return completion("パスワードを指定してください")}
        
        let header = ["Content-type": "application/json"]
        let params = ["name": name, "passowrd": pw]
        let pai = giftAPI
        let url = giftAPI
        Alamofire.request(api, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers)
    }
}
