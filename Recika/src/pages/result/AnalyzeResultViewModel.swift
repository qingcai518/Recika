//
//  AnalyzeResultViewModel.swift
//  Recika
//
//  Created by liqc on 2018/09/18.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AnalyzeResultViewModel {
    func saveReceiptData(receiptAt: String?, tel: String?, totalPrice: String?, adjustPrice: String?, items:[AnalyzerItemInfo]?, completion: @escaping (String?) -> Void) {
        guard let receiptAPI = URLComponents(string: receiptAPI) else {return completion("fail to get receipt API")}
        guard let itemAPI = URLComponents(string: itemAPI) else {return completion("fail to get item API")}
        guard let receiptAt = receiptAt else {return completion("have no receiptAt")}
        guard let tel = tel else {return completion("have no tel")}
        guard let totalPrice = totalPrice else {return completion("have no total price")}
        guard let adjustPrice = adjustPrice else {return completion("have no adjust price")}
        guard let items = items else {return completion("have not items")}
        
        let group = DispatchGroup()
        let params: [String: Any] = [
            "ReceiptAt" : receiptAt,
            "Tel": tel,
            "TotalPrice": totalPrice,
            "AdjustPrice": adjustPrice
        ]
        let headers = ["Content-Type": "application/json"]
        SVProgressHUD.show()
        
        Alamofire.request(receiptAPI, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let error = response.error {
                SVProgressHUD.dismiss()
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                SVProgressHUD.dismiss()
                return completion("fail to get data")
            }
            
            let json = JSON(data)
            let receiptId = json["ReceiptId"].intValue
            
            for i in 0..<items.count {
                let item = items[i]
                guard let name = item.name else {
                    continue
                }
                
                let itemName = name.takeUnretainedValue() as String
                let price = item.price
                
                let itemParams: [String: Any] = [
                    "receiptId": receiptId,
                    "name": itemName,
                    "price": price
                ]
                
                group.enter()
                DispatchQueue(label: "item\(i)").async(group: group) {
                    Alamofire.request(itemAPI, method: .post, parameters: itemParams, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                        if let error = response.error {
                            SVProgressHUD.dismiss()
                            return completion(error.localizedDescription)
                        }
                        
                        guard let data = response.data else {
                            SVProgressHUD.dismiss()
                            return completion("fail to get data")
                        }
                        
                        let json = JSON(data)
                        let itemId = json["ItemId"].intValue
                        print("item id = \(itemId)")
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main, execute: {
                SVProgressHUD.dismiss()
                return completion(nil)
            })
        }
    }
}
