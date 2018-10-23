//
//  PointDetailController.swift
//  Recika
//
//  Created by liqc on 2018/10/23.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class PointDetailController: ViewController {
    let topView = UIView()
    let iconView = UIImageView()
    let titleLbl = UILabel()
    let rateLbl = UILabel()
    let scrollView = UIScrollView()
    let exchangeBtn = UIButton()
    
    // params.
    var pointData: PointData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
    }
    
    private func setSubviews() {
        self.view.backgroundColor = UIColor.white
        
        var originY = statusbarHeight
        if let navigationHeight = self.navigationController?.navigationBar.frame.height {
            originY = originY + navigationHeight
        }
        
        var height = screenHeight - originY
        if let tabbarHeight = tabBarController?.tabBar.frame.height {
            height = height - tabbarHeight
        }
        scrollView.frame = CGRect(x: 0, y: originY, width: screenWidth, height: height)
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(topView)
        topView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 120)
        scrollView.addSubview(topView)
        
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        iconView.frame = CGRect(x: 24, y: 24, width: 60, height: 60)
        self.topView.addSubview(iconView)
        
        titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        titleLbl.textColor = UIColor.black
        titleLbl.numberOfLines = 1
        titleLbl.frame = CGRect(x: iconView.frame.maxX + 24, y: 24, width: screenWidth - 24 - iconView.frame.maxX - 24, height: 24)
        self.topView.addSubview(titleLbl)
        
        rateLbl.font = UIFont.systemFont(ofSize: 12)
        rateLbl.textColor = UIColor.blue
        rateLbl.numberOfLines = 1
        rateLbl.frame = CGRect(x: iconView.frame.maxX + 24, y: titleLbl.frame.maxY + 12, width: screenWidth - 24 - iconView.frame.maxX - 24, height: 16)
        self.topView.addSubview(rateLbl)
        
        if let pointData = self.pointData {
            iconView.image = pointData.logo
            titleLbl.text = "\(pointData.name) (\(pointData.symbol))"
            rateLbl.text = "\(pointData.rate) RCP"
        }
        
        // exchange button.
        exchangeBtn.layer.cornerRadius = 12
        exchangeBtn.clipsToBounds = true
        exchangeBtn.setBackgroundImage(UIImage.from(color: UIColor.orange), for: .normal)
        exchangeBtn.setBackgroundImage(UIImage.from(color: UIColor.lightGray), for: .highlighted)
        exchangeBtn.setTitleColor(UIColor.white, for: .normal)
        exchangeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        exchangeBtn.setTitle(str_exchange, for: .normal)
        self.view.addSubview(exchangeBtn)
        exchangeBtn.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
        
        exchangeBtn.rx.tap.bind { [weak self] in
            let next = UIViewController()
            self?.navigationController?.pushViewController(next, animated: true)
        }.disposed(by: disposeBag)
    }
}
