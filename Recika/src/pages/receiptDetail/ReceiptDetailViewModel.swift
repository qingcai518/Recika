//
//  ReceiptViewModel.swift
//  Recika
//
//  Created by liqc on 2018/09/20.
//  Copyright © 2018年 liqc. All rights reserved.
//

import RxSwift
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ReceiptDetailViewModel {
    var items = [ItemData]()
    
    func getItems(receiptId: Int, completion: @escaping (String?) -> Void) {
        guard let api = URLComponents(string: itemAPI) else {return}
        api.queryItems = [
            URLQueryItem(name: "receipt_id", value: receiptId)
        ]
        
        SVProgressHUD.show()
        Alamofire.request(api, method: .get).responseJSON { response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion("fail to get items data")
            }
            
            
        }
    }
}
