//
//  ExchangeCell.swift
//  Recika
//
//  Created by liqc on 2018/10/09.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ExchangeCell: UITableViewCell {
    static let id = "ExchangeCell"
    
    let targetLbl = UILabel()
    let countLbl = UILabel()
    let exchangeBtn = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countLbl.text = nil
        targetLbl.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviews() {
        targetLbl.textColor = UIColor.black
        targetLbl.font = UIFont.systemFont(ofSize: 16)
        targetLbl.numberOfLines = 1
        contentView.addSubview(targetLbl)
        
        countLbl.textColor = UIColor.black
        countLbl.font = UIFont.systemFont(ofSize: 16)
        countLbl.numberOfLines = 1
        contentView.addSubview(countLbl)
        
        exchangeBtn.setTitle(str_exchange, for: .normal)
        exchangeBtn.setTitleColor(UIColor.black, for: .normal)
        exchangeBtn.layer.cornerRadius = 8
        exchangeBtn.layer.borderColor = UIColor.lightGray.cgColor
        exchangeBtn.layer.borderWidth = 1
        contentView.addSubview(exchangeBtn)
        
        targetLbl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(24)
            make.left.equalToSuperview().inset(24)
            make.width.equalTo(64)
        }
        
        exchangeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(64)
        }
        
        countLbl.snp.makeConstraints { make in
            make.left.equalTo(targetLbl.snp.right).offset(12)
            make.right.equalTo(exchangeBtn.snp.left).offset(12)
            make.top.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configure(with data : RateData) {
        self.targetLbl.text = data.name

        let attribute1: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        
        let attribute2: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        let str1 = NSAttributedString(string: "\(data.count)", attributes: attribute1)
        let str2 = NSAttributedString(string: "(rate = \(data.rate)", attributes: attribute2)
        
        let str = NSMutableAttributedString()
        str.append(str1)
        str.append(str2)
        
        self.countLbl.attributedText = str
    }
}
