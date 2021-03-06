//
//  PointDetailController.swift
//  Recika
//
//  Created by liqc on 2018/10/23.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SVProgressHUD

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
            guard let pointData = self?.pointData else {
                return
            }
            
            SVProgressHUD.show()
            doWalletTransfer(amount: 2, symbol: pointData.symbol) { [weak self] str in
                SVProgressHUD.dismiss()
                if let str = str {
                    self?.showToast(text: str)
                } else {
                    self?.showToast(text: "success to broadcast transation.")
                }
            }
        }.disposed(by: disposeBag)
        
        // test button.
        let localBtn = UIButton()
        localBtn.layer.cornerRadius = 12
        localBtn.clipsToBounds = true
        localBtn.setBackgroundImage(UIImage.from(color: UIColor.green), for: .normal)
        localBtn.setBackgroundImage(UIImage.from(color: UIColor.lightGray), for: .highlighted)
        localBtn.setTitleColor(UIColor.white, for: .normal)
        localBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        localBtn.setTitle("本地广播", for: .normal)
        self.view.addSubview(localBtn)
        localBtn.snp.makeConstraints { make in
            make.bottom.equalTo(exchangeBtn.snp.top).offset(-24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
        localBtn.rx.tap.bind { [weak self] in
            guard let pointData = self?.pointData else {return}
            doTransferLocal(amount: 2, assetId: pointData.id, symbol: pointData.symbol, callback: { [weak self] msg in
                if let msg = msg {
                    SVProgressHUD.showError(withStatus: msg)
                } else {
                    self?.showToast(text: "Success!")
                }
            })
        }.disposed(by: disposeBag)
        
        // broadcast button.
        let broadBtn = UIButton()
        broadBtn.layer.cornerRadius = 12
        broadBtn.clipsToBounds = true
        broadBtn.setBackgroundImage(UIImage.from(color: UIColor.blue), for: .normal)
        broadBtn.setBackgroundImage(UIImage.from(color: UIColor.lightGray), for: .highlighted)
        broadBtn.setTitleColor(UIColor.white, for: .normal)
        broadBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        broadBtn.setTitle("服务器广播", for: .normal)
        self.view.addSubview(broadBtn)
        broadBtn.snp.makeConstraints { make in
            make.bottom.equalTo(localBtn.snp.top).offset(-24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(50)
        }
        broadBtn.rx.tap.bind { [weak self] in
            guard let pointData = self?.pointData else {return}
            SVProgressHUD.show()
            doTransfer(amount: 2, assetId: pointData.id, symbol: pointData.symbol, callback: { [weak self] msg in
                SVProgressHUD.dismiss()
                if let msg = msg {
                    SVProgressHUD.showError(withStatus: msg)
                } else {
                    self?.showToast(text: "Success!")
                }
            })
        }.disposed(by: disposeBag)
    }
}
