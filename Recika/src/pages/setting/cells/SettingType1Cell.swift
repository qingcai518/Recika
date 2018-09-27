//
//  SettingType1Cell.swift
//  Recika
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SnapKit

class SettingType1Cell: UITableViewCell {
    static let id = "SettingType1Cell"
    var titleLbl = UILabel()
    var detailLbl = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let iconView = UIImageView(image: rightIcon)
        iconView.contentMode = .scaleAspectFit
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        titleLbl.textColor = UIColor.black
        titleLbl.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        titleLbl.numberOfLines = 1
        contentView.addSubview(titleLbl)
        
        detailLbl.textColor = UIColor.black
        detailLbl.font = UIFont.systemFont(ofSize: 14)
        detailLbl.lineBreakMode = .byCharWrapping
        detailLbl.numberOfLines = 0
        contentView.addSubview(detailLbl)
        
        iconView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.left.equalTo(16)
            make.right.equalTo(iconView.snp.left).offset(16)
        }
        
        detailLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(8)
            make.left.bottom.equalToSuperview().inset(16)
            make.right.equalTo(iconView.snp.left).offset(16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: SettingData) {
        titleLbl.text = data.title
        detailLbl.text = data.detail
    }
}
