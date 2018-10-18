//
//  RateData.swift
//  Recika
//
//  Created by liqc on 2018/10/09.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

struct RateData {
    let baseSymbol: String
    let targetSymbol: String
    let baseName: String
    let targetName: String
    let rate: Double
    let count: Double
    
    init(baseSymbol: String, targetSymbol: String, baseName: String, targetName: String, rate: Double, count: Double) {
        self.baseSymbol = baseSymbol
        self.targetSymbol = targetSymbol
        self.baseName = baseName
        self.targetName = targetName
        self.rate = rate
        self.count = count
    }
}
