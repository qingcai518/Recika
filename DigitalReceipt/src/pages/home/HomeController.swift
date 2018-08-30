//
//  HomeController.swift
//  DigitalReceipt
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
        viewModel.getBalance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        view.backgroundColor = UIColor.white
        
        let bkView = UIView()
        bkView.backgroundColor = UIColor.white
        view.addSubview(bkView)
    
        let contentLbl = UILabel()
        contentLbl.textColor = UIColor.black
        contentLbl.text = "あなたのコイン数は：100 DRPです。"
        contentLbl.numberOfLines = 0
        contentLbl.textAlignment = .center
        contentLbl.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(contentLbl)
        contentLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            make.left.right.equalToSuperview().inset(24)
        }
        
        // コイン数を設定する.
        viewModel.balance.asObservable().map{"あなたのコイン数は：\($0)\(symbol)です。"}.bind(to: contentLbl.rx.text).disposed(by: disposeBag)

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
