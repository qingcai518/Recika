//
//  ChartDatasFetcher.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

enum TimeType: Int {
    case time5m
    case time15m
    case time30m
    case time1h
    case time2h
    case time4h
    case time6h
    case time1d
    case time1w
}

class ChartDatasFetcher: NSObject {
    
    /// 接口地址
    //    var apiURL = "https://www.okex.com/api/v1/"       //okex废了
    var apiURL = "https://api.gdax.com/products/"       //gdax稳定
    
    /// 全局唯一实例
    static let shared: ChartDatasFetcher = {
        let instance = ChartDatasFetcher()
        return instance
    }()
    
    // add for test.
    func getChartData(symbol: String, timeType: TimeType, size: Int, completion: @escaping (String?, [KlineChartData]) -> Void) {
        var marketDatas = [KlineChartData]()
        
        var granularity = 300
        switch timeType {
        case .time5m:
            granularity = 5 * 60
        case .time15m:
            granularity = 15 * 60
        case .time30m:
            granularity = 30 * 60
        case .time1h:
            granularity = 1 * 60 * 60
        case .time2h:
            granularity = 2 * 60 * 60
        case .time4h:
            granularity = 4 * 60 * 60
        case .time6h:
            granularity = 6 * 60 * 60
        case .time1d:
            granularity = 1 * 24 * 60 * 60
        case .time1w:
            granularity = 1 * 24 * 7 * 60 * 60
        }
        
        guard let urlCompnents = URLComponents(string: self.apiURL + symbol + "/candles?granularity=\(granularity)") else {
            return completion("fail to get url", marketDatas)
        }
        
        Alamofire.request(urlCompnents, method: .get).responseJSON { response in
            if let error = response.error {
                return completion(error.localizedDescription, marketDatas)
            }
            
            guard let data = response.data else {
                return completion("fail to get data", marketDatas)
            }
            
            let json = JSON(data)
            let chartDatas = json.arrayValue
            
            for data in chartDatas {
                let marketData = KlineChartData(json: data.arrayValue)
                marketDatas.append(marketData)
            }
            
            marketDatas.reverse()
            return completion(nil, marketDatas)
        }
    }
}
