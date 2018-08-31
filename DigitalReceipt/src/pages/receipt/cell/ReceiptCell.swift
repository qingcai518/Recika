//
//  ReceiptCell.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ReceiptCell : UICollectionViewCell {
    static let id = "ReceiptCell"
    let titleLbl = UILabel()
    let timeLbl = UILabel()
    let priceLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLbl.textColor = UIColor.black
        titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        titleLbl.textAlignment = .center
        titleLbl.numberOfLines = 1
        contentView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.height.equalTo(24)
        }
        
        timeLbl.textColor = UIColor.black
        timeLbl.font = UIFont.systemFont(ofSize: 14)
        timeLbl.textAlignment = .center
        timeLbl.numberOfLines = 1
        contentView.addSubview(timeLbl)
        timeLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        priceLbl.textColor = UIColor.orange
        priceLbl.font = UIFont.boldSystemFont(ofSize: 14)
        priceLbl.textAlignment = .center
        priceLbl.numberOfLines = 1
        contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.top.equalTo(timeLbl.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: ReceiptData) {
        titleLbl.text = data.name
        timeLbl.text = data.time
        priceLbl.text = "¥\(data.totalPrice)"
    }
}
