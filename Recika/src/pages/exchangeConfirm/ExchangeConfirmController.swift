//
//  ExchangeConfirmController.swift
//  Recika
//
//  Created by liqc on 2018/10/10.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ExchangeConfirmController: ViewController {
    let totalLbl = UILabel()
    let pointTf = UITextField()
    let targetNameLbl = UILabel()
    let baseNameLbl = UILabel()
    let resultLbl = UILabel()
    let confirmBtn = UIButton()
    
    // params.
    var rateData: RateData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
    }
    
    private func setSubviews() {
        if let name = rateData?.baseName {
            self.title = name + " " + str_exchange
        }
        self.view.backgroundColor = UIColor.white
        
        totalLbl.textColor = UIColor.black
        totalLbl.font = UIFont.systemFont(ofSize: 16)
        totalLbl.numberOfLines = 1
        if let rateData = self.rateData {
            totalLbl.text = "\(rateData.targetName) : \(rateData.count)"
        }
        view.addSubview(totalLbl)
        
        targetNameLbl.textColor = UIColor.black
        targetNameLbl.font = UIFont.systemFont(ofSize: 16)
        targetNameLbl.numberOfLines = 1
        targetNameLbl.text = rateData?.targetName
        view.addSubview(targetNameLbl)
        
        pointTf.textColor = UIColor.black
        pointTf.font = UIFont.systemFont(ofSize: 16)
        pointTf.placeholder = rateData?.targetName
        pointTf.keyboardType = .numberPad
        pointTf.borderStyle = .roundedRect
        view.addSubview(pointTf)
        
        baseNameLbl.textColor = UIColor.black
        baseNameLbl.font = UIFont.systemFont(ofSize: 16)
        baseNameLbl.numberOfLines = 1
        baseNameLbl.text = rateData?.baseName
        view.addSubview(baseNameLbl)
        
        resultLbl.textColor = UIColor.black
        resultLbl.font = UIFont.systemFont(ofSize: 16)
        resultLbl.numberOfLines = 1
        view.addSubview(resultLbl)
        
        confirmBtn.setTitle(str_confirm, for: .normal)
        confirmBtn.layer.cornerRadius = 12
        confirmBtn.layer.borderColor = UIColor.lightGray.cgColor
        confirmBtn.layer.borderWidth = 1
        confirmBtn.setTitleColor(UIColor.lightGray, for: .disabled)
        confirmBtn.setTitleColor(UIColor.orange, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(confirmBtn)
        
        totalLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.right.left.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
        
        targetNameLbl.snp.makeConstraints { make in
            make.top.equalTo(totalLbl.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.width.equalTo((screenWidth - 2 * 24) / 3)
            make.height.equalTo(50)
        }
        
        pointTf.snp.makeConstraints { make in
            make.top.equalTo(totalLbl.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(targetNameLbl.snp.left).offset(-24)
            make.height.equalTo(50)
        }
        
        baseNameLbl.snp.makeConstraints { make in
            make.top.equalTo(targetNameLbl.snp.bottom).offset(24)
            make.right.equalToSuperview().inset(24)
            make.width.equalTo((screenWidth - 2 * 24) / 3)
            make.height.equalTo(50)
        }
        
        resultLbl.snp.makeConstraints { make in
            make.top.equalTo(targetNameLbl.snp.bottom).offset(24)
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(baseNameLbl.snp.left).offset(-24)
            make.height.equalTo(50)
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(resultLbl.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
        
        pointTf.rx.text.asObservable().map{$0?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""}.bind(to: confirmBtn.rx.isEnabled).disposed(by: disposeBag)
        
        pointTf.becomeFirstResponder()
    }
}
