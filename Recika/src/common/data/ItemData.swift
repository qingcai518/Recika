//
//  ItemData.swift
//  Recika
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

struct ItemData {
    let id : Int
    let name : String
    let price : Double
    let count : Int
    
    init(id: Int, name: String, price: Double, count: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.count = count
    }
}
