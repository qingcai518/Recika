//
//  DetailController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/29.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class DetailController: ViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let detailLbl = UILabel()
    let imgView = UIImageView()
    let priceLbl = UILabel()
    let exchangeBtn = UIButton()
    
    var data: GiftData?
    
    func setParam(data: GiftData) {
        self.data = data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        view.backgroundColor = UIColor.white
        self.title = data?.name
        
        // scrollView
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // contentView
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalTo(view)  // 垂直滚动。
        }
        
        // imageView
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        if let thumbnail = data?.thumbnail {
            imgView.kf.setImage(with: URL(string: thumbnail))
        }
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(300)
        }
        
        // detailLbl
        detailLbl.textColor = UIColor.black
        detailLbl.text = data?.detail
        detailLbl.font = UIFont.systemFont(ofSize: 16)
        detailLbl.numberOfLines = 0
        contentView.addSubview(detailLbl)
        detailLbl.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // price label.
        if let price = data?.price {
            priceLbl.text = "¥\(price)"
        }
        priceLbl.textColor = UIColor.black
        priceLbl.textAlignment = .center
        contentView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.top.equalTo(detailLbl.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        // exchange button.
        exchangeBtn.setTitle("こちらの商品を交換する", for: .normal)
        exchangeBtn.setTitleColor(UIColor.black, for: .normal)
        exchangeBtn.layer.cornerRadius = 12
        exchangeBtn.clipsToBounds = true
        exchangeBtn.layer.borderColor = UIColor.lightGray.cgColor
        exchangeBtn.layer.borderWidth = 1
        self.contentView.addSubview(exchangeBtn)
        exchangeBtn.snp.makeConstraints { make in
            make.top.equalTo(detailLbl.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(36)
            make.height.equalTo(60)
        }
        
        
    }
}
