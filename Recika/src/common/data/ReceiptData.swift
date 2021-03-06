//
//  ReceiptData.swift
//  Recika
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ReceiptData {
    let id : Int
    let imagePath: String
    let hash: String?
    let tel : String?
    let receiptAt: String?
    let totalPrice: String?
    let adjustPrice: String?
    var items = [ItemData]()
    
    init(id: Int, imagePath: String, hash: String?, tel: String?, receiptAt: String?, totalPrice: String?, adjustPrice: String?, items:[ItemData]) {
        self.id = id
        self.imagePath = imagePath
        self.hash = hash
        self.tel = tel
        self.receiptAt = receiptAt
        self.totalPrice = totalPrice
        self.adjustPrice = adjustPrice
        self.items = items
    }
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.imagePath = json["imagePath"].stringValue
        self.hash = json["hash"].stringValue
        self.receiptAt = json["receiptAt"].stringValue
        self.tel = json["tel"].stringValue
        self.totalPrice = json["totalPrice"].stringValue
        self.adjustPrice = json["adjustPrice"].stringValue
    }
}
