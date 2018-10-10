//
//  RateData.swift
//  Recika
//
//  Created by liqc on 2018/10/09.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

struct RateData {
    var name: String
    var rate : Double
    
    init(name: String, rate: Double) {
        self.name = name
        self.rate = rate
    }
}
