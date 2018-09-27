//
//  ReceiptItemCell.swift
//  Recika
//
//  Created by liqc on 2018/09/19.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ReceiptItemCell: UITableViewCell {
    static let id = "ReceiptItemCell"
    lazy var nameLbl = UILabel()
    lazy var priceLbl = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubview() {
        priceLbl.textColor = UIColor.orange
        priceLbl.font = UIFont.systemFont(ofSize: 14)
        priceLbl.numberOfLines = 1
        contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(24)
            make.width.equalTo(120)
        }

        nameLbl.textColor = UIColor.blue
        nameLbl.font = UIFont.systemFont(ofSize: 14)
        nameLbl.numberOfLines = 1
        contentView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(priceLbl.snp.left)
        }
    }
    
    func configure(with data: ItemData) {
        priceLbl.text = "¥\(data.price)"
        nameLbl.text = data.name
    }
}
