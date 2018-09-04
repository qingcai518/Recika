//
//  UIScrollView.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/04.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToPage(_ page: Int) {
        UIView.animate(withDuration: 0.3) {
            self.contentOffset.x = self.frame.width * CGFloat(page)
        }
    }
}
