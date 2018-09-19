//
//  ReceiptData.swift
//  Recika
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

struct ReceiptData {
    let id : Int
    let imagePath: String
    let tel : String
    let receiptAt: String
    let totalPrice: Double
    let adjustPrice: Double
    let items : [ItemData]
    
    init(id: Int, imagePath: String, tel: String?, receiptAt: String?, totalPrice: Double?, adjustPrice: Double?, items:[ItemData]) {
        self.id = id
        self.tel = tel
        self.receiptAt = receiptAt
        self.totalPrice = totalPrice
        self.adjustPrice = adjustPrice
        self.items = items
    }
}
