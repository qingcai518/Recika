//
//  ReceiptDetailCell.swift
//  Recika
//
//  Created by liqc on 2018/09/19.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import Kingfisher

class ReceiptDetailCell: UITableViewCell {
    static let id = "ReceiptDetailCell"
    lazy var imgView = UIImageView()
    lazy var dateLbl = UILabel()
    lazy var telLbl = UILabel()
    lazy var totalPriceLbl = UILabel()
    lazy var adjustPriceLbl = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 8
        contentView.addSubview(imgView)
        let width: CGFloat = screenWidth / 2 - 2 * 24
        let height = width * 5 / 3
        imgView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(24)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        dateLbl.textColor = UIColor.black
        dateLbl.font = UIFont.systemFont(ofSize: 14)
        dateLbl.numberOfLines = 1
        contentView.addSubview(dateLbl)
        dateLbl.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.top.equalToSuperview().inset(24)
        }
        
        telLbl.textColor = UIColor.black
        telLbl.font = UIFont.systemFont(ofSize: 14)
        telLbl.numberOfLines = 1
        contentView.addSubview(telLbl)
        telLbl.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.top.equalTo(dateLbl.snp.bottom).offset(12)
        }
        
        totalPriceLbl.textColor = UIColor.black
        totalPriceLbl.font = UIFont.systemFont(ofSize: 14)
        totalPriceLbl.numberOfLines = 1
        contentView.addSubview(totalPriceLbl)
        totalPriceLbl.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.top.equalTo(telLbl.snp.bottom).offset(12)
        }
        
        adjustPriceLbl.textColor = UIColor.black
        adjustPriceLbl.font = UIFont.systemFont(ofSize: 14)
        adjustPriceLbl.numberOfLines = 1
        contentView.addSubview(adjustPriceLbl)
        adjustPriceLbl.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.top.equalTo(totalPriceLbl.snp.bottom).offset(12)
        }
    }
    
    func configure(with data: ReceiptData) {
        imgView.kf.setImage(with: URL(string: data.imagePath))
        dateLbl.text = data.receiptAt
        telLbl.text = data.tel
        totalPriceLbl.text = data.totalPrice
        adjustPriceLbl.text = data.adjustPrice
    }
}
