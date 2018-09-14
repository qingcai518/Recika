//
//  AnalyzeResultCell.swift
//  Recika
//
//  Created by liqc on 2018/09/14.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class AnalyzeResultCell: UITableViewCell {
    lazy var nameLbl = UILabel()
    lazy var priceLbl = UILabel()
    
    static let id = "AnalyzeResultCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLbl.textColor = UIColor.blue
        nameLbl.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.height.equalTo(40)
            make.top.bottom.equalToSuperview()
        }
        
        priceLbl.textColor = UIColor.orange
        priceLbl.font = UIFont.systemFont(ofSize: 14)
        priceLbl.textAlignment = .right
        contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.height.equalTo(nameLbl.snp.height)
            make.top.bottom.equalToSuperview()
        }
    }
    
    func configure(item: AnalyzerItemInfo) {
        if let name = item.name {
            nameLbl.text = name.takeRetainedValue() as String
        }
        priceLbl.text = "\(item.price)"
    }
}
