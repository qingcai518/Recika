//
//  GiftViewModel.swift
//  Recika
//
//  Created by liqc on 2018/08/29.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON

class GiftViewModel {
    var gifts = [GiftData]()
    
    func getGifts(completion : @escaping (String?)-> Void) {
        SVProgressHUD.show()
        Alamofire.request(giftAPI, method: .get).responseJSON { [weak self] response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion("have no data")
            }
            
            let json = JSON(data)
            let gifts = json.arrayValue.map{GiftData(json: $0)}
            print(gifts)
            self?.gifts = gifts
            return completion(nil)
        }
    }
}
