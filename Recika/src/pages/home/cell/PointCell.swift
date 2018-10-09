//
//  PointCell.swift
//  Recika
//
//  Created by liqc on 2018/10/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import RxSwift
import UIKit

class PointCell: UICollectionViewCell {
    static let id = "PointCell"
    
    var nameLbl = UILabel()
    var countLbl = UILabel()
    var baseCountLbl = UILabel()
    var exchangeBtn = UIButton()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLbl.text = nil
        countLbl.text = nil
        baseCountLbl.text = nil
        
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.layer.cornerRadius = 12
        self.contentView.clipsToBounds = true
        let btnWidth = (screenWidth - 3 * 24) / 3
        
        nameLbl.font = UIFont.boldSystemFont(ofSize: 14)
        nameLbl.textColor = UIColor.white
        contentView.addSubview(nameLbl)
        
        countLbl.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        countLbl.textColor = UIColor.white
        contentView.addSubview(countLbl)
        
        baseCountLbl.font = UIFont.boldSystemFont(ofSize: 14)
        baseCountLbl.textColor = UIColor.white
        contentView.addSubview(baseCountLbl)
        
        exchangeBtn.setTitle(str_exchange, for: .normal)
        exchangeBtn.setTitleColor(UIColor.black, for: .normal)
        exchangeBtn.layer.cornerRadius = 8
        exchangeBtn.layer.borderWidth = 1
        exchangeBtn.layer.borderColor = UIColor.lightGray
        exchangeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        contentView.addSubview(exchangeBtn)
        
        nameLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        countLbl.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        baseCountLbl.snp.makeConstraints { make in
            make.top.equalTo(countLbl.snp.bottom).offset(12)
            make.right.left.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        exchangeBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(24)
            make.width.equalTo(btnWidth)
            make.height.equalTo(64)
        }
        
        exchangeBtn.rx.tap.bind {
            print("hello exchange world.")
        }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(width data: PointData) {
        self.nameLbl.text = data.name
        self.countLbl.text = "\(data.count) \(data.symbol)"
        self.baseCountLbl.text = "\(data.baseCount) \(RecikaPoint)"
        self.contentView.backgroundColor = data.bkColor
    }
}
