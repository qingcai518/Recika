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
        id = json["Id"].intValue
        name = json["Name"].stringValue
        detail = json["Detail"].stringValue
        thumbnail = json["Thumbnail"].stringValue
        price = json["Price"].doubleValue
    }
}
