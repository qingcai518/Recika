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
    var items = [AnalyzerItemInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        let topView = UIView()
        let tableView = UITableView()
        let dateLbl = UILabel()
        let telLbl = UILabel()
        let totalPriceLbl = UILabel()
        let adjustPriceLbl = UILabel()

        view.addSubview(topView)
        view.addSubview(tableView)

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
        dateLbl.textAlignment = .left
        dateLbl.numberOfLines = 1
        dateLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(24)
        }

        telLbl.textColor = UIColor.black
        telLbl.font = UIFont.systemFont(ofSize: 16)
        telLbl.textAlignment = .left
        telLbl.numberOfLines = 1
        telLbl.snp.makeConstraints { make in
            make.top.equalTo(dateLbl.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
        }

        totalPriceLbl.textColor = UIColor.black
        totalPriceLbl.font = UIFont.systemFont(ofSize: 16)
        totalPriceLbl.textAlignment = .left
        totalPriceLbl.numberOfLines = 1
        totalPriceLbl.snp.makeConstraints { make in
            make.top.equalTo(telLbl.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
        }

        adjustPriceLbl.textColor = UIColor.black
        adjustPriceLbl.font = UIFont.systemFont(ofSize: 16)
        adjustPriceLbl.textAlignment = .left
        adjustPriceLbl.numberOfLines = 1
        adjustPriceLbl.snp.makeConstraints { make in
            make.top.equalTo(totalPriceLbl.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
        }

        dateLbl.text = paramDate == nil ? "日時：" : "日時：\(paramDate!)"
        telLbl.text = paramTel == nil ? "電話番号：" : "電話番号：\(paramTel!)"
        totalPriceLbl.text = paramTotalPrice == nil ? "合計金額：" : "合計金額：\(paramTotalPrice!)"
        adjustPriceLbl.text = paramAdjustPrice == nil ? "調整金額：" : "調整金額：\(paramAdjustPrice!)"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AnalyzeResultCell.self, forCellReuseIdentifier: AnalyzeResultCell.id)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension AnalyzeResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AnalyzeResultController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AnalyzeResultCell.id, for: indexPath) as! AnalyzeResultCell
        let item = items[indexPath.item]
        cell.configure(item: item)
        return cell
    }
}
