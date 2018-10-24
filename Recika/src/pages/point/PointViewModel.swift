//
//  PointViewModel.swift
//  Recika
//
//  Created by liqc on 2018/10/18.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class PointViewModel {
    var points = [PointData]()
    
    func getPointData(callback: @escaping Callback) {
        guard let api = URLComponents(string: assetsAPI) else {return}
        let headers = ["Content-type": "application/json"]
        let params = ["assets": [RecikaPoint, BPoint, DPoint]]
        
        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] response in
            if let error = response.error {
                return callback(error.localizedDescription)
            }
            
            guard let data = response.data else {
                return callback("fail to get data")
            }
            
            self?.points = JSON(data).arrayValue.map{PointData(json: $0)}
            return callback(nil)
        }
    }
}
