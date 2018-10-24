//
//  ExchangeConfirmViewModel.swift
//  Recika
//
//  Created by liqc on 2018/10/10.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ExchangeConfirmViewModel {
    func doExchange(count: Double, rateData: RateData, completion:@escaping (String?) -> Void) {
        guard let api = URLComponents(string: orderAPI) else {return}
        let params: [String: Any] = [
            "user_id": userName,
            "from_symbol": rateData.targetSymbol,
            "to_symbol": rateData.baseSymbol,
            "from_count": count,
            "to_count": count * rateData.rate
        ]
        
        print(params)
        
        let headers = [
            "Content-type": "application/json"
        ]
        SVProgressHUD.show()
        Alamofire.request(api, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            guard let data = response.data else {
                return completion("fail to get data.")
            }
            
            let json = JSON(data)
            print(json)
            return completion(nil)
        }
    }
}
