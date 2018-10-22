//
//  PointData.swift
//  Recika
//
//  Created by liqc on 2018/10/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 * 用于首页的信息展示.
 */
struct MyPointData {
    let name: String
    let symbol: String
    let count : Double
    let baseCount : Double
    let bkColor : UIColor
    
    init(json: JSON) {
        print(json)
        
        self.symbol = json["symbol"].stringValue
        self.count = json["amount"].doubleValue
        
        if self.symbol == BPoint {
            self.name = BPointName
            self.baseCount = count * BPT_RCP
            self.bkColor = UIColor.blue
        } else if self.symbol == DPoint {
            self.name = DPointName
            self.baseCount = count * DPT_RCP
            self.bkColor = UIColor.lightGray
        } else {
            self.name = RecikaPointName
            self.baseCount = count
            self.bkColor = UIColor.orange
        }
    }
}
