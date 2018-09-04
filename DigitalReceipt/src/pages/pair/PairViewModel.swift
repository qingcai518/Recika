
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
                let keywords = key.split(separator: ".")
                guard let title = keywords.last else {continue}
                var titleData = PairData(title: String(title))
                
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
}
