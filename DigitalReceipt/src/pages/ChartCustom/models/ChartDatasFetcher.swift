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
    func getChartData(symbol: String, timeType: TimeType, size: Int, completion: @escaping (Bool, [KlineChartData]) -> Void) {
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
            print("can not get url")
            return
        }
        Alamofire.request(urlCompnents, method: .get).responseJSON { response in
            if let error = response.error {
                print(error.localizedDescription)
            }
            guard let data = response.data else {
                print("can not get data")
                return
            }
            
            let json = JSON(data)
            print(json)
        }

        
        
        
//        // 快捷方式获得session对象
//        let session = URLSession.shared
//        // /BTC-USD/candles?granularity=300
//        let url = URL(string: self.apiURL + symbol + "/candles?granularity=\(granularity)")
//        //        let url = URL(string: self.apiURL + "kline.do?symbol=\(symbol)&type=\(timeType)&size=\(size)")
//        // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
//        let task = session.dataTask(with: url!, completionHandler: {
//            (data, response, error) in
//            if let data = data {
//
//                DispatchQueue.main.async {
//
//                    var marketDatas = [KlineChartData]()
//
//                    /*
//                     对从服务器获取到的数据data进行相应的处理.
//                     */
//                    do {
//                        let json = try JSON(data: data)
//                        let chartDatas = json.arrayValue
//                        for data in chartDatas {
//                            let marektdata = KlineChartData(json: data.arrayValue)
//                            marketDatas.append(marektdata)
//                        }
//                        marketDatas.reverse()
//                        callback(true, marketDatas)
//
//                    } catch _ {
//                        callback(false, marketDatas)
//                    }
//                }
//
//
//            }
//        })
//
//        // 启动任务
//        task.resume()
    }
    
    /// 获取服务API的K线数据
    ///
    /// - Parameters:
    ///   - symbol: 市场
    ///   - timeType: 时间周期
    ///   - size: 数据条数
    ///   - callback:
    func getRemoteChartData(symbol: String, timeType: String, size: Int,
                            callback:@escaping (Bool, [KlineChartData]) -> Void) {
        
        //        The granularity field must be one of the following values: {60, 300, 900, 3600, 21600, 86400}. Otherwise, your request will be rejected. These values correspond to timeslices representing one minute, five minutes, fifteen minutes, one hour, six hours, and one day, respectively.
        var granularity = 300
        switch timeType {
        case "5min":
            granularity = 5 * 60
        case "15min":
            granularity = 15 * 60
        case "30min":
            granularity = 30 * 60
        case "1hour":
            granularity = 1 * 60 * 60
        case "2hour":
            granularity = 2 * 60 * 60
        case "4hour":
            granularity = 4 * 60 * 60
        case "6hour":
            granularity = 6 * 60 * 60
        case "1day":
            granularity = 1 * 24 * 60 * 60
        case "1week":
            granularity = 7 * 24 * 60 * 60
        default:
            granularity = 300
        }
        
        // 快捷方式获得session对象
        let session = URLSession.shared
        // /BTC-USD/candles?granularity=300
        let url = URL(string: self.apiURL + symbol + "/candles?granularity=\(granularity)")
        //        let url = URL(string: self.apiURL + "kline.do?symbol=\(symbol)&type=\(timeType)&size=\(size)")
        // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
        let task = session.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if let data = data {
                
                DispatchQueue.main.async {
                    
                    var marketDatas = [KlineChartData]()
                    
                    /*
                     对从服务器获取到的数据data进行相应的处理.
                     */
                    do {
                        let json = try JSON(data: data)
                        let chartDatas = json.arrayValue
                        for data in chartDatas {
                            let marektdata = KlineChartData(json: data.arrayValue)
                            marketDatas.append(marektdata)
                        }
                        marketDatas.reverse()
                        callback(true, marketDatas)
                        
                    } catch _ {
                        callback(false, marketDatas)
                    }
                }
                
                
            }
        })
        
        // 启动任务
        task.resume()
    }
    
    
}
