//
//  SettingType2Cell.swift
//  Recika
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class SettingType2Cell: UITableViewCell {
    static let id = "SettingType2Cell"
    let titleLbl = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let iconView = UIImageView(image: rightIcon)
        iconView.contentMode = .scaleAspectFit
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        titleLbl.textColor = UIColor.black
        titleLbl.font = UIFont.systemFont(ofSize: 14)
        titleLbl.numberOfLines = 1
        contentView.addSubview(titleLbl)
        
        // set constraint.
        iconView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        titleLbl.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(16)
            make.right.equalTo(iconView.snp.left).offset(16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: SettingData) {
        titleLbl.text = data.title
    }
}
