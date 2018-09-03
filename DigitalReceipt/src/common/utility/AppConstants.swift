//
//  AppConstants.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/21.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let statusbarHeight = UIApplication.shared.statusBarFrame.height


var safeArea: UIEdgeInsets = {
    let defaultInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    if #available(iOS 11.0, *) {
        if let insets = UIApplication.shared.keyWindow?.safeAreaInsets {
            return insets
        }
    }
    
    return defaultInsets
}()

let symbol = "CYB"  // ユーザーのToken数

enum ToastPosition {
    case center
    case top
    case bottom
}
