//
//  PointData.swift
//  Recika
//
//  Created by liqc on 2018/10/19.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PointData {
    var id: String
    var symbol: String
    var name: String
    var precision: Int
    var rate: Double
    var logo: UIImage
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.symbol = json["symbol"].stringValue
        self.precision = json["precision"].intValue
        
        if symbol == RecikaPoint {
            self.name = RecikaPointName
            self.logo = recikaIcon
            self.rate = 1
        } else if symbol == BPoint {
            self.name = BPointName
            self.logo = bpointIcon
            self.rate = BPT_RCP
        } else {
            self.name = DPointName
            self.logo = dpointIcon
            self.rate = DPT_RCP
        }
    }
}
