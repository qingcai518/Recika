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
        iconView.image = pointData?.logo
        self.topView.addSubview(iconView)
        
        titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        titleLbl.textColor = UIColor.black
        titleLbl.numberOfLines = 1
        titleLbl.frame = CGRect(x: iconView.frame.maxX + 24, y: 24, width: screenWidth - 24 - iconView.frame.maxX - 24, height: 24)
        titleLbl.text = pointData?.name
        self.topView.addSubview(titleLbl)
        
        
    }
}
