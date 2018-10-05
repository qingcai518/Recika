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
    var addBtn = UIButton()
    
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
        self.contentView.backgroundColor = UIColor.orange
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: -10)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.8
        
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
        
        contentView.addSubview(exchangeBtn)
        contentView.addSubview(addBtn)
        
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
            make.left.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
            make.width.equalTo(btnWidth)
        }
        
        addBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
            make.width.equalTo(btnWidth)
        }
        
        exchangeBtn.rx.tap.bind {
            print("do exchanging")
        }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(width data: PointData) {
        self.nameLbl.text = data.name
        self.countLbl.text = "\(data.count) \(data.symbol)"
        self.baseCountLbl.text = "\(data.baseCount) \(RecikaPoint)"
    }
}
