//
//  PriceData.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/04.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import RxSwift

struct PriceData {
    let tokenName: String
    var latestPrice = Variable("-")
    var percentChange = Variable("-")
    
    init(tokenName: String, latestPrice: Double = 0, percentChange: Double = 0) {
        self.tokenName = tokenName
        self.latestPrice.value = latestPrice == 0 ? "-": String(format: "%.4f", Float(latestPrice))
        self.percentChange.value = "\(percentChange) %"
    }
}
