//
//  AppUtility.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

func generateQR(from content: String) -> UIImage? {
    guard let data = content.data(using: String.Encoding.utf8) else {return nil}
    let param: [String: Any] = [
        "inputMessage": data,
        "inputCorrectionLevel": "L"
    ]
    let filter = CIFilter(name: "CIQRCodeGenerator", withInputParameters: param)
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    guard let ciImage = filter?.outputImage?.transformed(by: transform) else {
        return nil
    }
    
    return UIImage(ciImage: ciImage)
}

func getHeight(width: CGFloat, text: String, font: UIFont) -> CGFloat {
    let height = CGFloat.greatestFiniteMagnitude
    let attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: font])
    let rect = attributedText.boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
    return rect.height
}

func getWidth(height: CGFloat, text: String, font: UIFont) -> CGFloat {
    let width = CGFloat.greatestFiniteMagnitude
    let attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: font])
    let rect = attributedText.boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
    return rect.width
}

func getHeight(width: CGFloat, text: NSAttributedString) -> CGFloat {
    let height = CGFloat.greatestFiniteMagnitude
    let tempLbl = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
    tempLbl.attributedText = text
    tempLbl.numberOfLines = 0
    tempLbl.sizeToFit()
    return tempLbl.frame.height
}

func touchID(completion: @escaping (String?) -> Void) {
    let context = LAContext()
    var error : NSError?
    let check = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    if !check {
        return completion("指纹识别没有开启")
    }
    
    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "请用指纹解锁") { success, error in
        if let error = error {
            return completion(error.localizedDescription)
        }
        
        if !success {
            return completion("指纹识别未成功")
        }
        
        return completion(nil)
    }
}
