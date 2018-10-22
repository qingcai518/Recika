//
//  PointCell.swift
//  Recika
//
//  Created by liqc on 2018/10/19.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class PointCell: UITableViewCell {
    static let id = "PointCell"
    
    let coinIcon = UIImageView()
    let titleLbl = UILabel()
    let nameLbl = UILabel()
    let rateLbl = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviews() {
        coinIcon.contentMode = .scaleAspectFit
        coinIcon.clipsToBounds = true
        contentView.addSubview(coinIcon)
        
        titleLbl.font = UIFont.systemFont(ofSize: 12)
        titleLbl.textColor = UIColor.black
        titleLbl.textAlignment = .center
        contentView.addSubview(titleLbl)
        
        nameLbl.font = UIFont.boldSystemFont(ofSize: 24)
        nameLbl.textColor = UIColor.black
        nameLbl.textAlignment = .left
        contentView.addSubview(nameLbl)
        
        rateLbl.font = UIFont.systemFont(ofSize: 12)
        rateLbl.textColor = UIColor.blue
        rateLbl.textAlignment = .left
        contentView.addSubview(rateLbl)
        
        coinIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(24)
            make.height.width.equalTo(44)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(coinIcon.snp.bottom)
            make.height.equalTo(20)
            make.width.equalTo(44)
            make.left.equalToSuperview().offset(24)
        }
        
        nameLbl.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(coinIcon.snp.right).offset(24)
            make.right.equalToSuperview().inset(24)
        }

        rateLbl.snp.makeConstraints { make in
            make.left.equalTo(coinIcon.snp.right).offset(24)
            make.right.equalToSuperview().offset(24)
            make.top.equalTo(nameLbl.snp.bottom).offset(12)
        }
    }
    
    func configure(with data: PointData) {
        coinIcon.image = data.logo
        titleLbl.text = data.symbol
        nameLbl.text = data.name
        rateLbl.text = "\(data.rate) RCP"
    }
}
