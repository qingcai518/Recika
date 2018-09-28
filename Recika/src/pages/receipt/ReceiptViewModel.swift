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
    var isLoading = false
    var receipts = [ReceiptData]()
    var page = 0
    let size = 3
    
    func getData(refresh: Bool, completion: @escaping (String?) -> Void) {
        if isLoading {return}
        isLoading = true
        
        if refresh {
            page = 0
            receipts = [ReceiptData]()
        }
        if page < 0 {
            isLoading = false
            return
        }
        
        getReceiptData { [weak self] msg in
            self?.isLoading = false
            return completion(msg)
        }
    }
    
    private func getReceiptData(completion: @escaping (String?)-> Void) {
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
            self?.receipts.append(contentsOf: receiptDatas)
            return completion(nil)
        }
    }
}
