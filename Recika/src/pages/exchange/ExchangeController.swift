//
//  ExchangeController.swift
//  Recika
//
//  Created by liqc on 2018/10/09.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ExchangeController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
    }
    
    private func setSubviews() {
        self.view.backgroundColor = UIColor.white
        self.title = str_exchange
        
        let closeBtn = UIButton()
        closeBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        closeBtn.setImage(close, for: .normal)
        
        let barItem = UIBarButtonItem(customView: closeBtn)
        self.navigationItem.rightBarButtonItem = barItem
        
        // add action.
        closeBtn.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}
