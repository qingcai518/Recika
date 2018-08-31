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
    let chartView = LineChartView()
    let viewModel = ChartViewModel()

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
        
        view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
        
        chartView.data = viewModel.getChartData()
    }
}
