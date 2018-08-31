//
//  ChartViewModel.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Charts

class ChartViewModel {
    func setChartData() {
        let data:[Double] = [0, 1, 1, 2, 3, 5, 8, 13]
        var chartEntrys = [ChartDataEntry]()
        for (i, d) in data.enumerated() {
            let entry = ChartDataEntry(x: Double(i), y: d)
            chartEntrys.append(entry)
        }
        
        let dataSet = LineChartDataSet(values: chartEntrys, label: "K Line")
        return LineChartData(dataSet: dataSet)
    }
}
