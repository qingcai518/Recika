//
//  ExchangeCell.swift
//  Recika
//
//  Created by liqc on 2018/10/09.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ExchangeCell: UITableViewCell {
    let targetLbl = UILabel()
    let rateLbl = UILabel()
    let exchangeBtn = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        targetLbl.text = nil
        rateLbl.text = nil
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
        
        rateLbl.textColor = UIColor.black
        rateLbl.font = UIFont.systemFont(ofSize: 16)
        rateLbl.numberOfLines = 1
        contentView.addSubview(rateLbl)
        
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
            make.center.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(64)
        }
        
        rateLbl.snp.makeConstraints { make in
            make.left.equalTo(targetLbl.snp.right).offset(12)
            make.right.equalTo(exchangeBtn.snp.left).offset(12)
            make.top.bottom.equalToSuperview().inset(24)
        }
    }
    
    func configure(with info: PointCell) {
        
    }
}
