//
//  GiftData.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/29.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GiftData {
    let name: String
    let detail: String
    let thumbnail: String
    let price: Double
    
    init(data: Any) {
        let json = JSON(data)
        name = json["name"].stringValue
        detail = json["detail"].stringValue
        thumbnail = json["thumbnail"].stringValue
        price = json["price"].doubleValue
    }
}
