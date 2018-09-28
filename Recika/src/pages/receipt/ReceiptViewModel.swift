//
//  ReceiptViewModel.swift
//  Recika
//
//  Created by liqc on 2018/08/30.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import SVProgressHUD

class ReceiptViewModel {
    var receipts = [ReceiptData]()
    var page = 0
    let size = 3
    
    func refresh(completion: @escaping (String?) -> Void) {
        page = 0
        receipts = [ReceiptData]()
        getReceiptData { msg in
            return completion(nil)
        }
    }
    
    func loadMore(completion: @escaping (String?) -> Void) {
        if page == -1 {return}
        getReceiptData { msg in
            return completion(nil)
        }
    }
    
    func getReceiptData(completion: @escaping (String?)-> Void) {
        guard var api = URLComponents(string: receiptAPI) else {
            return completion("can not get api")
        }
        
        api.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        
        SVProgressHUD.show()
        Alamofire.request(api, method: .get).responseJSON { [weak self] response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion("fail to get response data.")
            }
            
            let json = JSON(data)
            self?.page = json["next_page"].intValue
            let receiptDatas = json["data"].arrayValue.map{ReceiptData(json: $0)}
            self?.receipts.append(receiptDatas)
            return completion(nil)
        }
    }
}
