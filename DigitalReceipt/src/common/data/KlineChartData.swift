//
//  KlineChartData.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SwiftyJSON

struct KlineChartData {
    var time: Int = 0
    var lowPrice: Double = 0
    var highPrice : Double = 0
    var openPrice : Double = 0
    var closePrice: Double = 0
    var vol: Double = 0
    var symbol: String = ""
    var platform : String = ""
    var rise: Double = 0
    var timeType: String = ""
    
    var amplitude: Double = 0
    var amplitudeRatio: Double = 0
    
    init(time: Int, lowPrice: Double, highPrice: Double, openPrice: Double, closePrice: Double, vol: Double, symbol: String, platform: String, rise: Double, timeType: String) {
        self.time = time
        self.lowPrice = lowPrice
        self.highPrice = highPrice
        self.openPrice = openPrice
        self.closePrice = closePrice
        self.vol = vol
        self.symbol = symbol
        self.platform = platform
        self.rise = rise
        self.timeType = timeType
        
        if openPrice > 0 {
            amplitude = closePrice - openPrice
            amplitudeRatio = amplitude / openPrice * 100
        }
    }
}
