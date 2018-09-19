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
    
    func getReceiptData(completion: @escaping (String?) -> Void) {
        guard var api = URLComponents(string: receiptAPI) else {
            return completion("can not get api")
        }
        
        SVProgressHUD.show()
        Alamofire.request(api, method: .get).responseJSON { [weak self] response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion("fail to get response data")
            }
            
            let json = JSON(data)
            receipts = json.arrayValue.map{ReceiptData(json: $0)}
            return completion(nil)
        }
    }
}
