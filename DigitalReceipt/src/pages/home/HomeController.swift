//
//  HomeController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SnapKit

class HomeController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        
        setSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        let bkView = UIView()
        bkView.backgroundColor = UIColor.white
        view.addSubview(bkView)
        
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
