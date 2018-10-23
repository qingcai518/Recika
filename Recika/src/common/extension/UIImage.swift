//
//  UIImage.swift
//  Recika
//
//  Created by liqc on 2018/10/23.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func from(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
