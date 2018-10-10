//
//  RateData.swift
//  Recika
//
//  Created by liqc on 2018/10/09.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

struct RateData {
    let name : String
    let rate: Double
    let count: Double
    
    init(name: String, rate: Double, count: Double) {
        self.name = name
        self.rate = rate
        self.count = count
    }
}
