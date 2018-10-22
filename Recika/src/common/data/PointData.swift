//
//  PointData.swift
//  Recika
//
//  Created by liqc on 2018/10/19.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

struct PointData {
    var symbol: String
    var name: String
    var rate: Double
    var logo: UIImage
    
    init(symbol: String, name: String, rate: Double, logo: UIImage) {
        self.symbol = symbol
        self.name = name
        self.rate = rate
        self.logo = logo
    }
}
