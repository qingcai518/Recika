//
//  ReceiptCell.swift
//  Recika
//
//  Created by liqc on 2018/08/31.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import Kingfisher

class ReceiptCell : UICollectionViewCell {
    static let id = "ReceiptCell"
    lazy var imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubView() {
        contentView.addSubview(imgView)
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12
        imgView.layer.cornerRadius = 12
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.borderWidth = 1
        imgView.clipsToBounds = true
        imgView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func configure(with data: ReceiptData) {
        imgView.kf.setImage(with: URL(string: data.imagePath))
    }
}
