//
//  ChartController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import Charts

class ChartController: ViewController {
    let chartView = CombinedChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setSubViews() {
        view.backgroundColor = UIColor.white
        
        // add charts.
        let chartData = CombinedChartData()
        chartData.lineData
         = generateLineData()
        
        let titleLbl = UILabel()
        titleLbl.textColor = UIColor.black
        titleLbl.numberOfLines = 0
        titleLbl.textColor = UIColor.orange
        titleLbl.text = "コンテント"
        titleLbl.font = UIFont.systemFont(ofSize: 12)
        self.view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
    }
}
