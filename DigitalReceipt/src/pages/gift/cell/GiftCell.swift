//
//  GiftCell.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/29.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import Kingfisher

class GiftCell: UICollectionViewCell {
    static let id = "GiftCell"
    var thumbnailView = UIImageView()
    var priceLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true
        
        priceLbl.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 18)
        priceLbl.textColor = UIColor.white
        priceLbl.textAlignment = .right
        priceLbl.font = UIFont.systemFont(ofSize: 12)
        priceLbl.backgroundColor = UIColor.black
        priceLbl.alpha = 0.5
        priceLbl.layer.cornerRadius = 8
        priceLbl.clipsToBounds = true
        
        self.contentView.addSubview(thumbnailView)
        self.contentView.addSubview(priceLbl)
        
        // set constraint.
        thumbnailView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        priceLbl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(14)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with data: GiftData) {
        thumbnailView.kf.setImage(with: URL(string: data.thumbnail))
        priceLbl.text = "¥\(data.price)"
    }
}
