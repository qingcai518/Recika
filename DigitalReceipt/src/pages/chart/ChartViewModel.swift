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
    func getLineData() -> LineChartData {
        //リストを作り、グラフのデータを追加する方法（GitHubにあったCombinedChartViewとかMPAndroidChartのwikiを参考にしている
        let values: [Double] = [0, 254, 321, 512, 214, 444, 967, 101, 765, 228,
                                726, 253, 20, 123, 512, 448, 557, 223, 465, 291,
                                979, 134, 864, 481, 405, 711, 1106, 411, 455, 761]
        let values2: [Double] = [201,220,203,420,520,620,720,820,920,200,
                                 201,220,203,420,520,657,757,857,579,570,
                                 571,572,573,574,575,576,577,578,579,571]
        let date : [Double] = [1,2,3,4,5,6,7,8,9,10,
                               11,12,13,14,15,16,17,18,19,20,
                               21,22,23,24,25,26,27,28,29,30]
        let date2 : [Double] = [1,5,3,7,9,14,16,17,18,20,
                                21,24,25,26,27,28,29,30,32,36,
                                40,41,42,43,44,45,46,47,48,49]
        
        var entries = [ChartDataEntry]()
        for (i, value) in values.enumerated() {
            let entry = ChartDataEntry(x: date[i], y: value)
            entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
        }
    }
    
    
    func generateLineData() -> LineChartData
    {
        

        
        
        //DataSetを行うために必要なEntryの変数を作る　データによって入れるデータが違うため複数のentriesが必要になる？
        //多分、データ毎にappendまでをしていくことによってentriesを少なくすることはできると思う
        var entries: [ChartDataEntry] = Array()
        for (i, value) in values.enumerated(){
            entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
        }
        var entries2: [ChartDataEntry] = Array()
        for (i, value) in values2.enumerated(){
            entries2.append(ChartDataEntry(x: date2[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
        }
        
        //データを送るためのDataSet変数をリストで作る
        var linedata:  [LineChartDataSet] = Array()
        
        //リストにデータを入れるためにデータを成形している
        //データの数値と名前を決める
        lineDataSet = LineChartDataSet(values: entries, label: "Line chart unit test data")
        lineDataSet.drawIconsEnabled = false
        //グラフの線の色とマルの色を変えている
        lineDataSet.colors = [NSUIColor.red]
        lineDataSet.circleColors = [NSUIColor.red]
        //上で作ったデータをリストにappendで入れる
        linedata.append(lineDataSet)
        
        //上に同じ
        lineDataSet = LineChartDataSet(values: entries2, label: "test data2")
        lineDataSet.drawIconsEnabled = false
        lineDataSet.colors = [NSUIColor.blue]
        lineDataSet.circleColors = [NSUIColor.blue]
        linedata.append(lineDataSet)
        
        
        //データを返す。今回のデータは複数なのでdataSetsになる
        return LineChartData(dataSets: linedata)
    }
}
