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
    let tel : String?
    let receiptAt: String?
    let totalPrice: String?
    let adjustPrice: String?
    let items : [ItemData]
    
    init(id: Int, imagePath: String, tel: String?, receiptAt: String?, totalPrice: String?, adjustPrice: String?, items:[ItemData]) {
        self.id = id
        self.imagePath = imagePath
        self.tel = tel
        self.receiptAt = receiptAt
        self.totalPrice = totalPrice
        self.adjustPrice = adjustPrice
        self.items = items
    }
}
