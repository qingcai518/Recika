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
    var chartView = OKKLineView()
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
        
//        chartView.doubleTapHandle = { () -> Void in
//            self.dismiss(animated: true, completion: nil)
//        }
//        
//        view.addSubview(chartView)
//        chartView.snp.makeConstraints { make in
//            make.edges.equalTo(OKEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//        }
//        
//        viewModel.fetchData()
    }
}
