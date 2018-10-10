//
//  RateData.swift
//  Recika
//
//  Created by liqc on 2018/10/09.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

struct RateData {
    let baseName: String
    let targetName: String
    let rate: Double
    let count: Double
    
    init(baseName: String, targetName: String, rate: Double, count: Double) {
        self.baseName = baseName
        self.targetName = targetName
        self.rate = rate
        self.count = count
    }
}
