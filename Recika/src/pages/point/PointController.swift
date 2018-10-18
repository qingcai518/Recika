//
//  PointController.swift
//  Recika
//
//  Created by liqc on 2018/10/18.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SnapKit

class PointController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
    }
    
    private func setSubviews() {
        // backgroundColor.
        self.view.backgroundColor = UIColor.white
        
        // right button.
        let chartBtn = UIButton()
        chartBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        chartBtn.setImage(chart, for: .normal)
        
        let rightItem = UIBarButtonItem(customView: chartBtn)
        navigationItem.rightBarButtonItem = rightItem
        
        chartBtn.rx.tap.bind { [weak self] sender in
            let next = PairController()
            let navi = UINavigationController(rootViewController: next)
            self?.present(navi, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}
