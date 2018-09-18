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
    func saveReceiptData(data: ReceiptData, completion: @escaping (String?) -> Void) {
        guard let receiptAPI = URLComponents(string: receiptAPI) else {return completion("fail to get receipt API")}
        guard let itemAPI = URLComponents(string: itemAPI) else {return completion("fail to get item API")}
        
        let group = DispatchGroup()
        let params: [String: Any] = [
            "ReceiptAt" : data.receiptAt,
            "Tel": data.tel,
            "TotalPrice": data.totalPrice,
            "AdjustPrice": data.adjustPrice
        ]
        let headers = ["Content-Type": "application/json"]
        SVProgressHUD.show()
        
        group.enter()
        DispatchQueue(label: "receipt").async(group: group) {
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
                let id = json["ReceiptId"].intValue
                print("receipt id = \(id)")
                group.leave()
            }
        }
        
        for i in 0..<data.items.count {
            let item = data.items[i]
            let itemParams:[String: Any] = [
                "receiptId" : data.id,
                "name": item.name,
                "price": item.price
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
                    let id = json["ItemId"].intValue
                    print("item id = \(id)")
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            SVProgressHUD.dismiss()
            return completion(nil)
        }
    }
}
