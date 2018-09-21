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
        var height : CGFloat = 8 * 44
        
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12
        imgView.clipsToBounds = true
        contentView.addSubview(imgView)
        let width: CGFloat = screenWidth / 2 - 2 * 24
        height = width * 5 / 3 > height ? width * 5 / 3 : height
        
        imgView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(24)
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
        
        let dateTitleLbl = createTitleLbl(text: str_time)
        contentView.addSubview(dateTitleLbl)
        
        dateLbl = createLbl()
        contentView.addSubview(dateLbl)
        
        let telTitleLbl = createTitleLbl(text: str_tel)
        contentView.addSubview(telTitleLbl)
        
        telLbl = createLbl()
        contentView.addSubview(telLbl)
        
        let totalPriceTitleLbl = createTitleLbl(text: str_totalprice)
        contentView.addSubview(totalPriceTitleLbl)
        
        totalPriceLbl = createLbl()
        contentView.addSubview(totalPriceLbl)
        
        let adjustPriceTitleLbl = createTitleLbl(text: str_adjustprice)
        contentView.addSubview(adjustPriceTitleLbl)
        
        self.adjustPriceLbl = createLbl()
        contentView.addSubview(adjustPriceLbl)
        
        /// set constraints.
        dateTitleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        dateLbl.snp.makeConstraints { make in
            make.top.equalTo(dateTitleLbl.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        telTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(dateLbl.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        telLbl.snp.makeConstraints { make in
            make.top.equalTo(telTitleLbl.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        totalPriceTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(telLbl.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        totalPriceLbl.snp.makeConstraints { make in
            make.top.equalTo(totalPriceTitleLbl.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        adjustPriceTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(totalPriceLbl.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        adjustPriceLbl.snp.makeConstraints { make in
            make.top.equalTo(adjustPriceTitleLbl.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
    
    func configure(with data: ReceiptData) {
        imgView.kf.setImage(with: URL(string: data.imagePath))
        dateLbl.text = data.receiptAt
        telLbl.text = data.tel
        totalPriceLbl.text = data.totalPrice
        adjustPriceLbl.text = data.adjustPrice
    }
    
    private func createTitleLbl(text: String) -> UILabel {
        let titleLbl = UILabel()
        titleLbl.text = text
        titleLbl.font = UIFont.systemFont(ofSize: 14)
        titleLbl.textColor = UIColor.black
        titleLbl.textAlignment = .center
        titleLbl.numberOfLines = 1
        titleLbl.layer.cornerRadius = 4
        titleLbl.layer.borderColor = UIColor.lightGray.cgColor
        titleLbl.layer.borderWidth = 1
        return titleLbl
    }
    
    private func createLbl() -> UILabel {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.blue
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        return lbl
    }
}
