//
//  ItemData.swift
//  Recika
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ItemData {
    let id : Int
    let name : String
    let price : Double
    
    init(id: Int, name: String, price: Double) {
        self.id = id
        self.name = name
        self.price = price
    }
    
    init(json: JSON) {
        self.id = json["Id"].intValue
        self.name = json["Name"].stringValue
        self.price = json["Price"].doubleValue
    }
}
