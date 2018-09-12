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
    let name : String
    let time : String
    let items : [ItemData]
    let totalPrice :Double
    
    init(id: Int, name: String, time: String, items:[ItemData], totalPrice: Double) {
        self.id = id
        self.name = name
        self.time = time
        self.items = items
        self.totalPrice = totalPrice
    }
}
