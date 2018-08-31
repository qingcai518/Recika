//
//  ChartController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import CHKLineChartKit

class ChartController: ViewController {
    let viewModel = ChartViewModel()
    
    lazy var chartView : CHKLineChartView = {
        let view = CHKLineChartView(frame: CGRect.zero)
        view.style = .base
        view.delegate = self
        return view
    }()
    
    lazy var timeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(UIColor.orange, for: .normal)
        return btn
    }()
    
    lazy var indexBtn: UIButton =  {
        let btn = UIButton()
        btn.setTitle("Params", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        return btn
    }()
    
    lazy var styleBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Style", for: .normal)
        btn.setTitleColor(UIColor.orange, for: .normal)
        return btn
    }()
    
    lazy var marketBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.orange, for: .normal)
        let symbol = self.viewModel.exPairs[self.viewModel.selectedSymbol]
        btn.setTitle(symbol + "📈", for: .normal)
        return btn
    }()
    
    lazy var toolbarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setSubViews() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(chartView)
        view.addSubview(timeBtn)
        view.addSubview(indexBtn)
        view.addSubview(styleBtn)
        
        handleChartIndexChanged()
        fetchData()
    }
    
    private func fetchData() {
        viewModel.fetchData()
    }
    
    private func handleChartIndexChanged() {
        let linKey = viewModel.masterLine[viewModel.selectedMasterLine]
        let masterKey = viewModel.masterIndex[viewModel.selectedMasterindex]
        let assistKey = viewModel.assistIndex[viewModel.selectedAssistIndex]
        let assist2key = viewModel.assistIndex[viewModel.selectedAssistIndex2]
        
        self.chartView.setSection(hidden: assistKey == "", byIndex: 1)
        self.chartView.setSection(hidden: assist2key == "", byIndex: 2)
        
        chartView.setSerie(hidden: true, inSection: 0)
        chartView.setSerie(hidden: true, inSection: 1)
        chartView.setSerie(hidden: true, inSection: 2)
        
        chartView.setSerie(hidden: false, by: masterKey, inSection: 0)
        chartView.setSerie(hidden: false, by: assistKey, inSection: 1)
        chartView.setSerie(hidden: false, by: assist2key, inSection: 2)
        chartView.setSerie(hidden: false, by: lineKey, inSection: 0)
        
        self.chartView.reloadData(resetData: false)
    }
    
}

extension ChartController: CHKLineChartDelegate {
    func numberOfPointsInKLineChart(chart: CHKLineChartView) -> Int {
        return viewModel.klineDatas.count
    }
}
