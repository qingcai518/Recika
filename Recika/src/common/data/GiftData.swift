//
//  GiftData.swift
//  Recika
//
//  Created by liqc on 2018/08/29.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GiftData {
    let id: Int
    let name: String
    let detail: String
    let thumbnail: String
    let price: Double
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        detail = json["detail"].stringValue
        thumbnail = json["thumbnail"].stringValue
        price = json["price"].doubleValue
    }
}
