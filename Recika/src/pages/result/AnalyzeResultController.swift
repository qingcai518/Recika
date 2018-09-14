//
//  AnalyzeResultController.swift
//  Recika
//
//  Created by liqc on 2018/09/14.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class AnalyzeResultController: ViewController {
    var paramDate: String?
    var paramTel: String?
    var paramTotalPrice: String?
    var paramAdjustPrice: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    private func setupUI() {
//        view.backgroundColor = UIColor.white
//        let topView = UIView()
//        let tableView = UITableView()
//        let dateLbl = UILabel()
//        let telLbl = UILabel()
//        let totalPriceLbl = UILabel()
//        let adjustPriceLbl = UILabel()
//
//        view.addSubview(topView)
//
//        topView.addSubview(dateLbl)
//        topView.addSubview(telLbl)
//        topView.addSubview(totalPriceLbl)
//        topView.addSubview(adjustPriceLbl)
//
//        topView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(120)
//        }
//
//        dateLbl.textColor = UIColor.orange
//        dateLbl.font = UIFont.systemFont(ofSize: 16)
//        dateLbl.textAlignment = .center
//        dateLbl.numberOfLines = 1
//        dateLbl.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(12)
//            make.left.right.equalToSuperview()
//        }
//
//        telLbl.textColor = UIColor.black
//        telLbl.font = UIFont.systemFont(ofSize: 16)
//        telLbl.textAlignment = .center
//        telLbl.numberOfLines = 1
//        telLbl.snp.makeConstraints { make in
//            make.top.equalTo(dateLbl.snp.bottom).offset(12)
//            make.left.right.equalToSuperview()
//        }
//
//        totalPriceLbl.textColor = UIColor.black
//        totalPriceLbl.font = UIFont.systemFont(ofSize: 16)
//        totalPriceLbl.textAlignment = .center
//        totalPriceLbl.numberOfLines = 1
//        totalPriceLbl.snp.makeConstraints { make in
//            make.top.equalTo(telLbl.snp.bottom).offset(12)
//            make.left.right.equalToSuperview()
//        }
//
//        adjustPriceLbl.textColor = UIColor.black
//        adjustPriceLbl.font = UIFont.systemFont(ofSize: 16)
//        adjustPriceLbl.textAlignment = .center
//        adjustPriceLbl.numberOfLines = 1
//        adjustPriceLbl.snp.makeConstraints { make in
//            make.top.equalTo(totalPriceLbl.snp.bottom).offset(12)
//            make.left.right.equalToSuperview()
//        }
//
//        if let info = info {
//            dateLbl.text = "\(info.date.year)年\(info.date.month)月\(info.date.day)日 \(info.date.hour):\(info.date.minute):\(info.date.second)"
//            telLbl.text = info.tel.takeRetainedValue() as String
//            totalPriceLbl.text = "¥\(info.total)"
//            adjustPriceLbl.text = "¥\(info.priceAdjustment)"
//        }
//    }
}
