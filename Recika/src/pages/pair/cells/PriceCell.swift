//
//  PriceCell.swift
//  Recika
//
//  Created by liqc on 2018/09/04.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import RxSwift

class PriceCell: UITableViewCell {
    static let id = "PriceCell"
    let tokenLbl = UILabel()
    let riseView = UIView()
    let riseLbl = UILabel()
    let priceLbl = UILabel()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        tokenLbl.text = nil
        riseLbl.text = nil
        priceLbl.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubViews() {
        tokenLbl.textColor = UIColor.black
        tokenLbl.textAlignment = .left
        tokenLbl.font = UIFont.boldSystemFont(ofSize: 18)
        self.contentView.addSubview(tokenLbl)
        tokenLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(24)
            make.width.equalTo(120)
        }
        
        riseView.layer.cornerRadius = 8
        riseView.clipsToBounds = true
        riseView.backgroundColor = UIColor.green
        self.contentView.addSubview(riseView)
        riseView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        riseLbl.textColor = UIColor.black
        riseLbl.textAlignment = .center
        riseLbl.font = UIFont.boldSystemFont(ofSize: 14)
        riseLbl.numberOfLines = 1
        riseView.addSubview(riseLbl)
        riseLbl.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        priceLbl.textColor = UIColor.black
        priceLbl.textAlignment = .right
        priceLbl.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.right.equalTo(riseView.snp.left).offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
    }
    
    func configure(with data: PriceData) {
        if let last = data.tokenName.split(separator: ".").last {
            self.tokenLbl.text = String(last)
        }
        
        data.latestPrice.asObservable().bind(to: priceLbl.rx.text).disposed(by: disposeBag)
        data.percentChange.asObservable().bind { [weak self] value in
            self?.riseLbl.backgroundColor = value.starts(with: "-") ? UIColor.red : UIColor.green
            self?.riseLbl.text = value
        }.disposed(by: disposeBag)
    }
}
