//
//  ResultController.swift
//  Recika
//
//  Created by liqc on 2018/09/13.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ResultController: ViewController {
    let topView = UIView()
    let dateLbl = UILabel()
    let telLbl = UILabel()
    let totalPriceLbl = UILabel()
    let adjustPriceLbl = UILabel()
    
    // params.
    var info : AnalyzerReceiptInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupSubViews() {
        view.addSubview(topView)
//        view.addSubview(tableView)
        
        topView.addSubview(dateLbl)
        topView.addSubview(telLbl)
        topView.addSubview(totalPriceLbl)
        topView.addSubview(adjustPriceLbl)
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        dateLbl.textColor = UIColor.orange
        dateLbl.font = UIFont.systemFont(ofSize: 16)
        dateLbl.textAlignment = .center
        dateLbl.numberOfLines = 1
        dateLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview()
        }
        
        telLbl.textColor = UIColor.black
        telLbl.font = UIFont.systemFont(ofSize: 16)
        telLbl.textAlignment = .center
        telLbl.numberOfLines = 1
        telLbl.snp.makeConstraints { make in
            make.top.equalTo(dateLbl.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        totalPriceLbl.textColor = UIColor.black
        totalPriceLbl.font = UIFont.systemFont(ofSize: 16)
        totalPriceLbl.textAlignment = .center
        totalPriceLbl.numberOfLines = 1
        totalPriceLbl.snp.makeConstraints { make in
            make.top.equalTo(telLbl.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        adjustPriceLbl.textColor = UIColor.black
        adjustPriceLbl.font = UIFont.systemFont(ofSize: 16)
        adjustPriceLbl.textAlignment = .center
        adjustPriceLbl.numberOfLines = 1
        adjustPriceLbl.snp.makeConstraints { make in
            make.top.equalTo(totalPriceLbl.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        if let info = info {
            dateLbl.text = "\(info.date.year)年\(info.date.month)月\(info.date.day)日 \(info.date.hour):\(info.date.minute):\(info.date.second)"
            telLbl.text = info.tel.takeRetainedValue() as String
            totalPriceLbl.text = "¥\(info.total)"
            adjustPriceLbl.text = "¥\(info.priceAdjustment)"
        }
        
//        /// tableView
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.tableFooterView = UIView()
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.snp.makeConstraints { make in
//            make.top.equalTo(topView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
    }
}

//extension ResultController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
//extension ResultController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.contentView.backgroundColor = UIColor.yellow
//        return cell
//    }
//}
