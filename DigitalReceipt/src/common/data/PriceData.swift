//
//  PriceData.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/04.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

struct PriceData {
    let tokenName: String
    let price: Double
    
    init(tokenName: String, price: Double = 0.0) {
        self.tokenName = tokenName
        self.price = price
    }
}
