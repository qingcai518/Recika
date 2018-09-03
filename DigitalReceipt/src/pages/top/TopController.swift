//
//  ViewController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/21.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class TopController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: HomeController())
        let item1 = UITabBarItem(title: str_home, image: tabIcon1, tag: 0)
        vc1.tabBarItem = item1
        
        let vc2 = UINavigationController(rootViewController: ReceiptController())
        let item2 = UITabBarItem(title: str_receipt, image: tabIcon2, tag: 1)
        vc2.tabBarItem = item2
        
        let chart = ChartCustomViewController()
        let vc3 = UINavigationController(rootViewController: chart)
        let item3 = UITabBarItem(title: str_chart, image: tabIcon3, tag: 2)
        vc3.tabBarItem = item3
        
        let vc4 = UINavigationController(rootViewController: GiftController())
        let item4 = UITabBarItem(title: str_gift, image: tabIcon4, tag: 3)
        vc4.tabBarItem = item4
        
        let vc5 = UINavigationController(rootViewController: SettingController())
        let item5 = UITabBarItem(title: str_setting, image: tabIcon5, tag: 4)
        vc5.tabBarItem = item5
        
        viewControllers = [vc1, vc2, vc3, vc4, vc5]
    }
}
