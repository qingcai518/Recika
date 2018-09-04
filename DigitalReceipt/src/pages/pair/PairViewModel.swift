
//
//  PairViewMode3l.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Alamofire
import SVProgressHUD

class PairViewModel {
    var titles = [PairData]()
    
    func getPairs(completion: @escaping (String?) -> Void) {
        guard let api = URLComponents(string: pairsAPI) else {return}
        
        SVProgressHUD.show()
        Alamofire.request(api, method: .get).responseJSON { [weak self] response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            guard let data = response.data else {
                return completion("can not get assets pairs.")
            }
            
            let json = JSON(data)
            let assetDic = json.dictionaryValue
            for key in assetDic.keys {
                var titleData = PairData(title: key)
                
                var prices = [PriceData]()
                if let values = assetDic[key]?.arrayValue {
                    prices = values.map{PriceData(tokenName: $0.stringValue)}
                }
                titleData.prices = prices
                
                self?.titles.append(titleData)
            }
            self?.titles.first?.selected.value = true
            return completion(nil)
        }
    }
    
    func getTicker(from: String, to: String) {
        
        
//        guard var api = URLComponents(string: tickerAPI) else {return}
//        api.queryItems = [
//
//        ]
//
//        SVProgressHUD.show()
//        Alamofire.request(api, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//            SVProgressHUD.dismiss()
//            if let error = response.error {
//                print(error.localizedDescription)
//                return
//            }
//            print(response.data)
//        }
    }
}
