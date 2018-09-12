//
//  PairTabCell.swift
//  Recika
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import RxSwift

class PairTabCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
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
        titleLbl.font = UIFont.boldSystemFont(ofSize: 14)
        contentView.addSubview(titleLbl)
        
        titleLbl.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
    
    func configure(with data: PairData) {
        if let last = data.tokenName.split(separator: ".").last {
            self.titleLbl.text = String(last)
        }
        
        data.selected.asObservable().bind { [weak self] value in
            self?.titleLbl.textColor = value ? UIColor.red : UIColor.black
        }.disposed(by: disposeBag)
    }
}
