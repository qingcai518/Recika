//
//  DetailController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/29.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class DetailController: ViewController {
    var scrollView = UIScrollView()
    var detailLbl = UILabel()
    var imgView = UIImageView()
    var priceLbl = UILabel()
    var exchangeBtn = UIButton()
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
        
        // set scrollView.
        scrollView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        scrollView.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        
        // add parts to scrollView.
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        if let thumbnail = data?.thumbnail {
            imgView.kf.setImage(with: URL(string: thumbnail))
        }
        scrollView.addSubview(imgView)
        
        detailLbl.textColor = UIColor.black
        detailLbl.numberOfLines = 0
        detailLbl.font = UIFont.systemFont(ofSize: 14)
        detailLbl.text = data?.detail
        scrollView.addSubview(detailLbl)
        
        // set constraint.
        imgView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        detailLbl.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}
