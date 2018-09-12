//
//  KlineChartData.swift
//  Recika
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct KlineChartData {
    var time: Int = 0
    var lowPrice: Double = 0
    var highPrice: Double = 0
    var openPrice: Double = 0
    var closePrice: Double = 0
    var vol: Double = 0
    var symbol: String = ""
    var platfom: String = ""
    var rise: Double = 0
    var timeType: String = ""
    //振幅
    var amplitude: Double = 0
    var amplitudeRatio: Double = 0
    
    init(json: [JSON]) {
        self.time = json[0].intValue
        self.highPrice = json[2].doubleValue
        self.lowPrice = json[1].doubleValue
        self.openPrice = json[3].doubleValue
        self.closePrice = json[4].doubleValue
        self.vol = json[5].doubleValue
        
        //振幅
        if self.openPrice > 0 {
            self.amplitude = self.closePrice - self.openPrice
            self.amplitudeRatio = self.amplitude / self.openPrice * 100
        }
    }
    
    init(json: JSON) {
        let timeStr = json["key", "open"].stringValue
        let highBase = json["high_base"].doubleValue
        let lowBase = json["low_base"].doubleValue
        let highQuote = json["high_quote"].doubleValue
        let lowQuote = json["low_quote"].doubleValue
        let openBase = json["open_base"].doubleValue
        let openQuote = json["open_quote"].doubleValue
        let closeBase = json["close_base"].doubleValue
        let closeQuote = json["close_quote"].doubleValue
        let volumeBase = json["base_volume"].doubleValue
        let volumeQuote = json["quote_volume"].doubleValue
        
        if let timeISO = getDateISO(from: timeStr) {
            self.time = Int(timeISO.timeIntervalSince1970)
        }
        
        self.highPrice = highBase / highQuote
        self.lowPrice = lowBase / lowQuote
        self.openPrice = openBase / openQuote
        self.closePrice = closeBase / closeQuote
        self.vol = volumeBase / volumeQuote
        
        if openPrice > 0 {
            self.amplitude = self.closePrice - self.openPrice
            self.amplitude = self.amplitude / self.openPrice * 100
        }
    }
}
