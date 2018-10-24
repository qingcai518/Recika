//
//  AppUtility.swift
//  Recika
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
    
    let filter = CIFilter(name: "CIQRCodeGenerator", parameters: param)
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    guard let ciImage = filter?.outputImage?.transformed(by: transform) else {
        return nil
    }
    
    return UIImage(ciImage: ciImage)
}

func getHeight(width: CGFloat, text: String, font: UIFont) -> CGFloat {
    let height = CGFloat.greatestFiniteMagnitude
    let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
    let rect = attributedText.boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
    return rect.height
}

func getWidth(height: CGFloat, text: String, font: UIFont) -> CGFloat {
    let width = CGFloat.greatestFiniteMagnitude
    let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
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

// 处理日期相关的函数.
func getDate(from str: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.locale = Locale(identifier: "ja_JP")
    return formatter.date(from: str)
}

func getDateISO(from str: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.locale = Locale(identifier: "ja_JP")
    return formatter.date(from: str)
}

func getDateStr(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.locale = Locale(identifier: "ja_JP")
    return formatter.string(from: date)
}

func getDateISOStr(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.locale = Locale(identifier: "ja_JP")
    return formatter.string(from: date)
}

func lastDay() -> Date {
    let now = Date()
    return now.addingTimeInterval(-24 * 60 * 60)
}

func monthBefore(m: Int) -> Date? {
    let now = Date()
    let fromDate = Calendar.current.date(byAdding: .month, value: -m, to: now)
    return fromDate
}

func zeroDay() -> Date? {
    let now = Date()
    let calendar = Calendar(identifier: Calendar.Identifier.japanese)
    let components = calendar.dateComponents([.year, .month, .day], from: now)
    return calendar.date(from: components)
}

func getSymbol(tokenName: String) -> String {
    if let last = tokenName.split(separator: ".").last {
        return String(last)
    } else {
        return tokenName
    }
}

/// color and image.
func createImageByColor(color: UIColor, scale: Double) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1 * scale)
    UIGraphicsBeginImageContext(rect.size)
    
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

// 得到一个ID获取最后一个数据
func getLastNum(from userId: String) -> Int32 {
    if let last = userId.split(separator: ".").last {
        let lastStr = String.init(last)
        if let result = Int32(lastStr) {
            return result
        } else {
            return 0
        }
    } else {
        return 0
    }
}
