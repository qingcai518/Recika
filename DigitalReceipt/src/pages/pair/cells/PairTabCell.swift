//
//  PairTabCell.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class PairTabCell: UICollectionViewCell {
    static let id = "PairTabCell"
    let titleLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        titleLbl.textAlignment = .center
        titleLbl.numberOfLines = 1
        contentView.addSubview(titleLbl)
        
        titleLbl.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func configure(with title: String, isSelected: Bool) {
        self.titleLbl.text = title
        self.titleLbl.textColor = isSelected ? UIColor.red : UIColor.black
        self.titleLbl.font = isSelected ? UIFont.systemFont(ofSize: 14, weight: .semibold) : UIFont.systemFont(ofSize: 14)
    }
}
