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
    var isLoading = false
    var page = 0
    let size = 2
    
    func getData(refresh : Bool, completion: @escaping (String?) -> Void) {
        if isLoading {
            return
        }
        isLoading = true
        
        if refresh {
            gifts = [GiftData]()
            page = 0
        }
        
        if page == -1 {
            isLoading = false
            return
        }
        
        getGifts { [weak self] msg in
            self?.isLoading = false
            return completion(msg)
        }
    }
    
    private func getGifts(completion : @escaping (String?)-> Void) {
        print("get gift")
        
        SVProgressHUD.show()
        guard var api = URLComponents(string: giftAPI) else {return completion(nil)}
        api.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        
        Alamofire.request(api, method: .get).responseJSON { [weak self] response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return completion("have no data")
            }
            
            let json = JSON(data)
            self?.page = json["next_page"].intValue
            let giftDatas = json["data"].arrayValue.map{GiftData(json: $0)}
            self?.gifts.append(contentsOf: giftDatas)
            return completion(nil)
        }
    }
}
