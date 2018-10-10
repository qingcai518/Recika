//
//  ExchangeConfirmController.swift
//  Recika
//
//  Created by liqc on 2018/10/10.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ExchangeConfirmController: ViewController {
    let pointTf = UITextField()
    let resultLbl = UILabel()
    let confirmBtn = UIButton()
    
    // params.
    var rateData: RateData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
    }
    
    private func setSubviews() {
        pointTf.textColor = UIColor.black
        pointTf.font = UIFont.systemFont(ofSize: 16)
        pointTf.placeholder = rateData?.targetName
        view.addSubview(pointTf)
        
        resultLbl.textColor = UIColor.black
        resultLbl.font = UIFont.systemFont(ofSize: 16)
        resultLbl.numberOfLines = 1
        view.addSubview(resultLbl)
        
        confirmBtn.setTitle(str_confirm, for: .normal)
        confirmBtn.setTitleColor(UIColor.lightGray, for: .disabled)
        confirmBtn.setTitleColor(UIColor.orange, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(confirmBtn)
    }
}
