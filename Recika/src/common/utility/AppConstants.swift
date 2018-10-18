//
//  AppConstants.swift
//  Recika
//
//  Created by liqc on 2018/08/21.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

// statusbarの高さ.
let statusbarHeight = UIApplication.shared.statusBarFrame.height

// tabbar の高さを取得する.
func tabHeight(_ tabbarController: UITabBarController?) -> CGFloat {
    guard let tabbarController = tabbarController else {return 0}
    return tabbarController.tabBar.frame.height
}

// navigation barの高さを取得する.
func naviheight(_ naviController: UINavigationController?) -> CGFloat {
    guard let naviController = naviController else {return 0}
    return naviController.navigationBar.frame.height
}

// safe area領域
var safeArea: UIEdgeInsets = {
    let defaultInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    if #available(iOS 11.0, *) {
        if let insets = UIApplication.shared.keyWindow?.safeAreaInsets {
            return insets
        }
    }
    
    return defaultInsets
}()

enum ToastPosition {
    case center
    case top
    case bottom
}

/** 系统支持的Point. */
let RecikaPointName = "Recika Point"
let BPointName = "B Point"
let DPointName = "D Point"

let RecikaPoint = "RCP"
let BPoint = "BPT"
let DPoint = "DPT"

let PointDic = [
    RecikaPoint: RecikaPointName,
    BPoint: BPointName,
    DPoint: DPointName
]

// TODO. 比率，暂时固定.
let BPT_RCP: Double = 10
let DPT_RCP: Double = 25

let SupportSymbols = [
    RecikaPoint, BPoint, DPoint
]

// response.
typealias Callback = (String?) -> Void
