
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
    var titles = [PairTabData]()
    var prices = [PriceData]()
    
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
                let titleData = PairTabData(title: String(title))
                self?.titles.append(titleData)
                
                if let values = assetDic[key]?.arrayValue {
                    self?.prices = values.map{PriceData(tokenName: $0.stringValue)}
                }
            }
            self?.titles.first?.selected.value = true
            return completion(nil)
        }
    }
}
