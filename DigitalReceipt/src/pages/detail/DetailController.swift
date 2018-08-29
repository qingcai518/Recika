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
        
//        contentView.addSubview(priceLbl)
//        priceLbl.snp.makeConstraints { make in
//            make.top.equalTo(detailLbl.snp.bottom).offset(24)
//            make.left.right.equalToSuperview().inset(24)
//            make.height.equalTo(24)
//        }
        
        // exchange button.
        exchangeBtn.setTitle("こちらの商品を交換する", for: .normal)
        exchangeBtn.setTitleColor(UIColor.black, for: .normal)
        exchangeBtn.layer.cornerRadius = 12
        exchangeBtn.clipsToBounds = true
        exchangeBtn.layer.borderColor = UIColor.lightGray.cgColor
        exchangeBtn.layer.borderWidth = 1
        view.addSubview(exchangeBtn)
        
        exchangeBtn.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
            make.left.right.equalToSuperview().inset(36)
            make.height.equalTo(60)
        }
        
        exchangeBtn.rx.tap.bind { [weak self] in
            let alert = UIAlertController(title: "交換", message: "交換します、よろしいですか", preferredStyle: .actionSheet)
            let action1 = UIAlertAction(title: "はい", style: .default, handler: { action in
                print("do exchange")
            })
            
            print("222222")
            
            let action2 = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
            alert.addAction(action1)
            alert.addAction(action2)
            self?.present(alert, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        // price label.
        if let price = data?.price {
            priceLbl.text = "¥\(price)"
        }
        priceLbl.textColor = UIColor.black
        priceLbl.textAlignment = .center
        view.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.bottom.equalTo(exchangeBtn.snp.top).offset(-12)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
    }
}
