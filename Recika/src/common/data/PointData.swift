//
//  PointData.swift
//  Recika
//
//  Created by liqc on 2018/10/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

// TODO. 比率，暂时固定.
let BPT_RCP: Double = 10
let DPT_RCP: Double = 25

struct PointData {
    let name: String
    let symbol: String
    let count : Double
    let baseCount : Double
    let bkColor : UIColor
    
//    init(name: String, symbol: String, count: Double, baseCount: Double) {
//        self.name = name
//        self.symbol = symbol
//        self.count = count
//        self.baseCount = baseCount
//        self.bkColor = UIColor.orange
//    }
    
    init(json: JSON) {
        self.symbol = json["symbol"].stringValue
        self.count = json["amount"].doubleValue
        
        if self.symbol == BPoint {
            self.name = BPointName
            self.baseCount = count * BPT_RCP
            self.bkColor = UIColor.blue
        } else if self.symbol == DPoint {
            self.name = DPointName
            self.baseCount = count * DPT_RCP
            self.bkColor = UIColor.green
        } else {
            self.name = RecikaPointName
            self.baseCount = count
            self.bkColor = UIColor.orange
        }
    }
}
