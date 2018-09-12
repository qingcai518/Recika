//
//  UIViewController.swift
//  Recika
//
//  Created by liqc on 2018/08/28.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    func showToast(position: ToastPosition = .center, text: String, font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = UIColor.white, bkColor: UIColor = UIColor.black, alpha: CGFloat = 0.5) {
        let toast = UIView()
        toast.layer.cornerRadius = 12
        toast.clipsToBounds = true
        toast.backgroundColor = bkColor
        toast.alpha = alpha
        
        let margin: CGFloat = 36
        let padding: CGFloat = 8
        let width = screenWidth - 2 * margin
        let textWidth = width - 2 * padding
        let textHeight = getHeight(width: textWidth, text: text, font: font)
        let height = textHeight + 2 * padding
        toast.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let lbl = UILabel()
        lbl.textColor = textColor
        lbl.textAlignment = .center
        lbl.text = text
        lbl.font = font
        lbl.backgroundColor = UIColor.clear
        lbl.numberOfLines = 0
        lbl.frame = CGRect(x: padding, y: padding, width: textWidth, height: textHeight)
        toast.addSubview(lbl)
        
        switch position {
        case .center:
            toast.center = view.center
        case .top:
            toast.frame.origin.y = 24
        case .bottom:
            toast.frame.origin.y = screenHeight - height - 24
        }
        
        view.addSubview(toast)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            toast.removeFromSuperview()
        }
    }
}
