//
//  HomeController.swift
//  Recika
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class HomeController: ViewController {
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startGetBalance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopGetBalance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        view.backgroundColor = UIColor.white
        
        let bkView = UIView()
        bkView.backgroundColor = UIColor.white
        view.addSubview(bkView)
        
        let balanceTitleLbl = UILabel()
        balanceTitleLbl.textColor = UIColor.black
        balanceTitleLbl.text = str_your_coin
        balanceTitleLbl.textAlignment = .center
        balanceTitleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(balanceTitleLbl)
        balanceTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(24)
        }
        
        let balanceLbl = UILabel()
        balanceLbl.textColor = UIColor.orange
        balanceLbl.textAlignment = .center
        balanceLbl.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(balanceLbl)
        balanceLbl.snp.makeConstraints { make in
            make.top.equalTo(balanceTitleLbl.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(30)
        }
    
        // コイン数を設定する.
        viewModel.balance.asObservable().map{"\($0) \(symbol)"}.bind(to: balanceLbl.rx.text).disposed(by: disposeBag)
        
        // 屏幕中间的欢迎信息.
        let welcomeLbl = UILabel()
        welcomeLbl.textColor = UIColor.black
        welcomeLbl.font = UIFont.boldSystemFont(ofSize: 20)
        print("user name = \(userName)")
        let welcomeMsg = localize(key: "welcome", arguments: userName)
        print("welcome messge = \(welcomeMsg)")
        welcomeLbl.text = welcomeMsg
        welcomeLbl.numberOfLines = 1
        view.addSubview(welcomeLbl)
        welcomeLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 下方二维码的view
        let titleLbl = UILabel()
        titleLbl.textColor = UIColor.white
        titleLbl.textAlignment = .center
        titleLbl.backgroundColor = UIColor.orange
        titleLbl.text = msg1
        bkView.addSubview(titleLbl)
        
        print("生成二维码")
        let qrCodeView = UIImageView()
        qrCodeView.image = generateQR(from: "\(userName)\n\(ownerPubKey)\n\(activePubKey)\n\(memoPubKey)\n")
        bkView.addSubview(qrCodeView)
        
        bkView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.left.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.equalTo(view)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        qrCodeView.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
    }
}
