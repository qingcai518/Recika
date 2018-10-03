//
//  PointData.swift
//  Recika
//
//  Created by liqc on 2018/10/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PointData {
    let name: String
    let count : Double
    let baseCount : Double
    
    init(name: String, count: Double, baseCount: Double) {
        self.name = name
        self.count = count
        self.baseCount = baseCount
    }
    
    init(json: JSON) {
        self.name = json["symbol"].stringValue
        self.count = json["amount"].doubleValue
        self.baseCount = count  // dummy.
    }
}
