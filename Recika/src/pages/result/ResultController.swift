//
//  ResultController.swift
//  Recika
//
//  Created by liqc on 2018/09/13.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ResultController: ViewController {
    let tableView = UITableView()
    let topView = UIView()
    let dateLbl = UILabel()
    let telLbl = UILabel()
    let totalPriceLbl = UILabel()
    let adjustPriceLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupSubViews() {
        view.addSubview(topView)
        view.addSubview(tableView)
        
        topView.addSubview(dateLbl)
        topView.addSubview(telLbl)
        topView.addSubview(totalPriceLbl)
        topView.addSubview(adjustPriceLbl)
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
    }
}

extension ResultController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ResultController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
