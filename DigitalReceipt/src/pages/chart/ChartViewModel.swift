//
//  ChartViewModel.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Charts
import Alamofire
import SwiftyJSON

class ChartViewModel {
    func getChartData() -> LineChartData {
        let data:[Double] = [0, 1, 1, 2, 3, 5, 8, 13]
        var chartEntrys = [ChartDataEntry]()
        for (i, d) in data.enumerated() {
            let entry = ChartDataEntry(x: Double(i), y: d)
            chartEntrys.append(entry)
        }
        
        let dataSet = LineChartDataSet(values: chartEntrys, label: "K Line")
        return LineChartData(dataSet: dataSet)
    }
    
    func fetchData() {
        let param = [
            "type": "5min",
            "symbol": "okcoincnbtccny",
            "size": "300"
        ]
        
        let api = "https://www.btc123.com/kline/klineapi"
        Alamofire.request(api, method: .get, parameters: param).responseJSON { response in
            if let error = response.error {
                print(error.localizedDescription)
            }
            
            guard let data = response.data else {
                print("can not get data.")
                return
            }
            
            let json = JSON(data)
            print(json)
        }
    }
}
