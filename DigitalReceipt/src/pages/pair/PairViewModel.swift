
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
                var titleData = PairData(tokenName: key)
                
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
    
    func getAllTickers() {
        for title in titles {
            let prices = title.prices
            for price in prices {
                let from = title.tokenName
                let to = price.tokenName
                
                self.getTicker(from: from, to: to) { data, msg in
                    if let msg = msg {
                        print(msg)
                        return
                    }
                    guard let priceData = data else {
                        print("can not get data")
                        return
                    }
                    
                    print(data)
                    price.latestPrice.value = priceData.latestPrice.value
                }
            }
        }
    }
    
    // do post request.
    func getTicker(from: String, to: String, completion: @escaping (PriceData?, String?) -> Void) {
        guard let api = URLComponents(string: tickerAPI) else {
            return completion(nil, "can not found url")
        }
        
        let params = ["from": from, "to": to]
        let headers = ["Content-Type": "application/json"]
        print(api)
        
//        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
//            if let error = response.error {
//                print(error)
//                return
//            }
//
//            guard let data = response.data else {
//                print("fail to get data")
//                return
//            }
//
//            let result = String(data: data, encoding: String.Encoding.utf8)
//
//            print(result)
//        }
        
        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let error = response.error {
                return completion(nil, error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion(nil, "fail to get data")
            }
            
            let json = JSON(data)
            
            if let errorMsg = json["error", "data", "message"].string {
                return completion(nil, errorMsg)
            }
            
            let latest = json["result", "latest"].doubleValue
            let priceData = PriceData(tokenName: to, latestPrice: latest)
            return completion(priceData, nil)
        }
    }
    
    // do get request.
//    func getTicker(from: String, to: String, completion: @escaping (PriceData?, String?) -> Void) {
//        guard var api = URLComponents(string: tickerAPI) else {
//            return completion(nil, "can not found url")
//        }
//        api.queryItems = [
//            URLQueryItem(name: "from", value: from),
//            URLQueryItem(name: "to", value: to)
//        ]
//
//        print(api)
//        Alamofire.request(api, method: .get).responseJSON { response in
//            if let error = response.error {
//                return completion(nil, error.localizedDescription)
//            }
//
//            guard let data = response.data else {
//                return completion(nil, "fail to get data")
//            }
//
//            let json = JSON(data)
//            print(json)
//            let latest = json["latest"].doubleValue
//            let priceData = PriceData(tokenName: to, latestPrice: latest)
//
//            return completion(priceData, nil)
//        }
//    }
}
