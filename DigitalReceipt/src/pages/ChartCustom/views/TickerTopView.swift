//
//  TickerTopView.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

import UIKit

class TickerTopView : UIView {
    lazy var priceLbl: UILabel = {
        let priceLbl = UILabel()
        priceLbl.textColor = UIColor(hex: 0x00bd9a)
        priceLbl.font = UIFont.systemFont(ofSize: 26)
        return priceLbl
    }()
    
    lazy var riseLbl : UILabel = {
        let riseLbl = UILabel()
        riseLbl.textColor = UIColor(hex: 0xfe9d25)
        riseLbl.font = UIFont.systemFont(ofSize: 12)
        return riseLbl
    }()
    
    lazy var openLbl: UILabel = {
        let openLbl = UILabel()
        openLbl.textColor = UIColor(hex: 0xfe9d25)
        openLbl.font = UIFont.systemFont(ofSize: 12)
        return openLbl
    }()
    
    lazy var closeLbl: UILabel = {
        let closeLbl = UILabel()
        closeLbl.textColor = UIColor(hex: 0xfe9d25)
        closeLbl.font = UIFont.systemFont(ofSize: 12)
        return closeLbl
    }()
    
    lazy var highLbl : UILabel = {
        let highLbl = UILabel()
        highLbl.textColor = UIColor(hex: 0xfe9d25)
        highLbl.font = UIFont.systemFont(ofSize: 12)
        return highLbl
    }()
    
    lazy var lowLbl : UILabel = {
        let lowLbl = UILabel()
        lowLbl.textColor = UIColor(hex: 0xfe9d25)
        lowLbl.font = UIFont.systemFont(ofSize: 12)
        return lowLbl
    }()
    
    lazy var volLbl: UILabel = {
        let volLbl = UILabel()
        volLbl.textColor = UIColor(hex:0xfe9d25)
        volLbl.font = UIFont.systemFont(ofSize: 12)
        return volLbl
    }()
    
    lazy var turnoverLbl : UILabel = {
        let turnoverLbl = UILabel()
        turnoverLbl.textColor = UIColor(hex: 0xfe9d25)
        turnoverLbl.font = UIFont.systemFont(ofSize: 12)
        return turnoverLbl
    }()
    
    lazy var marginLbl: UILabel = {
        let marginLbl = UILabel()
        marginLbl.textColor = UIColor(hex: 0xfe9d25)
        marginLbl.font = UIFont.systemFont(ofSize: 12)
        return marginLbl
    }()
    
    
    // left column.
    let leftStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 0
        view.alignment = .fill
        return view
    }()
    
    let rightStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 0
        view.alignment = .fill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        self.addSubview(leftStack)
        self.addSubview(rightStack)
        
        let left1 = UIStackView()
        left1.axis = .horizontal
        left1.distribution = .fillEqually
        left1.spacing = 8
        left1.alignment = .fill
        
        left1.addArrangedSubview(marginLbl)
        left1.addArrangedSubview(riseLbl)
        
        self.leftStack.addArrangedSubview(priceLbl)
        self.leftStack.addArrangedSubview(left1)
        
        let right1 = UIStackView()
        right1.axis = .horizontal
        right1.distribution = .fillEqually
        right1.spacing = 8
        right1.alignment = .fill
        
        right1.addArrangedSubview(highLbl)
        right1.addArrangedSubview(openLbl)
        
        let right2  = UIStackView()
        right2.axis = .horizontal
        right2.distribution = .fillEqually
        right2.spacing = 8
        right2.alignment = .fill
        
        right2.addArrangedSubview(self.lowLbl)
        right2.addArrangedSubview(self.closeLbl)
        
        let right3 = UIStackView()
        right3.axis = .horizontal
        right3.distribution = .fillEqually
        right3.spacing = 8
        right3.alignment = .fill
        right3.addArrangedSubview(self.volLbl)
        right3.addArrangedSubview(self.turnoverLbl)
        
        self.rightStack.addArrangedSubview(right1)
        self.rightStack.addArrangedSubview(right2)
        self.rightStack.addArrangedSubview(right3)
        
        self.setupConstraints()
    }
    
    func setupConstraints() {
        self.leftStack.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(rightStack.snp.left)
            make.top.bottom.equalToSuperview()
        }
        
        self.rightStack.snp.makeConstraints { make in
            make.width.equalTo(self.leftStack.snp.width)
            make.right.top.bottom.equalToSuperview()
        }
    }
    
    func update(data: KlineChartData) {
        priceLbl.text = "\(data.closePrice)"
        riseLbl.text = "\(data.amplitudeRatio.toString(maxF: 2))%"
        marginLbl.text = "\(data.amplitude.toString(maxF: 4))"
        openLbl.text = "O" + " " + "\(data.openPrice.toString(maxF: 4))"
        highLbl.text = "H" + " " + "\(data.highPrice.toString(maxF: 4))"
        lowLbl.text = "L" + " " + "\(data.lowPrice.toString(maxF: 4))"
        closeLbl.text = "C" + " " + "\(data.closePrice.toString(maxF: 4))"
        volLbl.text = "V" + " " + "\(data.vol.toString(maxF: 2))"
        let turnover = data.vol * data.closePrice
        turnoverLbl.text = "T" + " " + "\(turnover.toString(maxF: 2))"
        
    }
    
}
