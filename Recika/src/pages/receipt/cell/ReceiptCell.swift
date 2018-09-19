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
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 12
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.addSubview(imgView)
    }
    
    func configure(with data: ReceiptData) {
        imgView.kf.setImage(with: data.imagePath)
    }
}
