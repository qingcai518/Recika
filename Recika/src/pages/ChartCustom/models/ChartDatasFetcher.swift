//
//  ChartDatasFetcher.swift
//  Recika
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

//enum TimeType: String {
//    case time5m = "5min"
//    case time15m = "15min"
//    case time30m = "30min"
//    case time1h = "1hour"
//    case time2h = "2hour"
//    case time4h = "4hour"
//    case time6h = "6hour"
//    case time1d = "1day"
//    case time1w = "1week"
//}

enum TimeType: Int {
    case t15 = 15
    case t60 = 60
    case t300 = 300
    case t3600 = 3600
    case t86400 = 86400
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
    func getChartData(symbol: String, timeType: TimeType, completion: @escaping (String?, [KlineChartData]) -> Void) {
        var marketDatas = [KlineChartData]()
        
        let granularity = 300 // dummy.
//        var granularity = 300
//        switch timeType {
//        case .time5m:
//            granularity = 5 * 60
//        case .time15m:
//            granularity = 15 * 60
//        case .time30m:
//            granularity = 30 * 60
//        case .time1h:
//            granularity = 1 * 60 * 60
//        case .time2h:
//            granularity = 2 * 60 * 60
//        case .time4h:
//            granularity = 4 * 60 * 60
//        case .time6h:
//            granularity = 6 * 60 * 60
//        case .time1d:
//            granularity = 1 * 24 * 60 * 60
//        case .time1w:
//            granularity = 1 * 24 * 7 * 60 * 60
//        }
        
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
            
            print(chartDatas)
            
            for data in chartDatas {
                let marketData = KlineChartData(json: data.arrayValue)
                marketDatas.append(marketData)
            }
            
            marketDatas.reverse()
            return completion(nil, marketDatas)
        }
    }
    
    func getMarket(from: String, to: String, timeType: TimeType, completion: @escaping (String?, [KlineChartData]) -> Void) {
        var result = [KlineChartData]()
        guard let api = URLComponents(string: klineAPI) else {
            return completion("fail to get url", result)
        }
        
        let currentStr = getDateISOStr(from: Date())   // 获取当天时间.
        guard let before = monthBefore(m: 3) else {
            return completion("fail to get start time", result)
        }
        let startStr = getDateISOStr(from: before)
        
//        let start = Date(timeIntervalSince1970: 0)    // 开始时间.
//        let startStr = getDateISOStr(from: start)

        let params: [String: Any] = ["from": from, "to": to, "time_type": timeType.rawValue, "start": startStr, "end": currentStr]
        let headers = ["Content-Type": "application/json"]
        
        print(params)
        
        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let error = response.error {
                return completion(error.localizedDescription, result)
            }
            
            guard let data = response.data else {
                return completion("fail to get data", result)
            }
            
            let json = JSON(data)
            _ = json.arrayValue.map{KlineChartData(json: $0)}.map{result.append($0)}
            
            return completion(nil, result)
        }
    }
}
