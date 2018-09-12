
//
//  PairViewMode3l.swift
//  Recika
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
    var timer: Timer?
    
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
    
    func startGetTickers() {
        getAllTickers()
        stopGetTickers()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] _ in
            self?.getAllTickers()
        })
    }
    
    func stopGetTickers() {
        timer?.invalidate()
        timer = nil
    }
    
    private func getAllTickers() {
        print("====== [\(getDateStr(from: Date()))] start get tickers ======")
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
                    
                    price.latestPrice.value = priceData.latestPrice.value
                    price.percentChange.value = priceData.percentChange.value
                }
            }
        }
    }
    
    // do post request.
    private func getTicker(from: String, to: String, completion: @escaping (PriceData?, String?) -> Void) {
        guard let api = URLComponents(string: tickerAPI) else {
            return completion(nil, "can not found url")
        }
        
        let params = ["from": from, "to": to]
        let headers = ["Content-Type": "application/json"]
        
        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let error = response.error {
                return completion(nil, error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion(nil, "fail to get data")
            }
            
            let json = JSON(data)
            let latest = json["latest"].doubleValue
            let percentChange = json["percent_change"].doubleValue
            let price = PriceData(tokenName: to, latestPrice: latest, percentChange: percentChange)
            return completion(price, nil)
        }
    }
}
