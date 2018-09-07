//
//  CameraController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/07.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class CameraController: ViewController {
    var picData:Data?
    var picSize: CGSize?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getReceiptResult(receiptInfo: AnalyzerReceiptInfo) -> String {
        var result = "\(receiptInfo.date.year)年\(receiptInfo.date.month)月\(receiptInfo.date.day)日 \(receiptInfo.date.hour)時\(receiptInfo.date.minute)分\(receiptInfo.date.second)秒\n"
        result = result + "電話番号: \(receiptInfo.tel)\n"
        result = result + "合計金額: \(receiptInfo.total)"
        result = result + "調整金額: \(receiptInfo.priceAdjustment)"
        
        let items = receiptInfo.items
        print(items)
        
        return result
    }
    
    private func execReceiptAnalyzeNormal() {
        guard let picData = picData else {return}
        guard let picSize = picSize else {return}
        guard let picImage = UIImage(data: picData) else {return}
        
        print("picture size = \(picSize.width), \(picSize.height)")
        
        let size8M = SIZE_8M
        let wMax = WIDTH_MAX
        let hMax = HEIGHT_MAX
        let width = picImage.size.width
        let height = picImage.size.height
        let pixelSize = width * height
        let pictureAspectKind = self.getAspectRatioKind(width: width, height : height)
        let ocrWidth = width
        let ocrHeight = height
        
        if (pixelSize != size8M) {
            if (pictureAspectKind == ASPECT_RATIO_STANDARD) {
                ocrWidth = RECEIPT_8M_HRZ_HEIGHT;
                ocrHeight = RECEIPT_8M_HRZ_WIDTH;
            } else if (pictureAspectKind == ASPECT_RATIO_WIDE) {
                ocrWidth = RECEIPT_4K_HRZ_HEIGHT;
                ocrHeight = RECEIPT_4K_HRZ_WIDTH;
            } else {
                let zoomRate = (Float)sqrt((Float)((Float)size8M / (Float)pixelSize))
                if (width > height) {
                    let preWidth = (Float)width * zoomRate
                    if (preWidth > wMax) {
                        zoomRate = (Float)wMax / (Float)width;
                    }
                } else {
                    let preHeight = (Float)height * zoomRate
                    if (preHeight > hMax) {
                        zoomRate = (Float)hMax / (Float) height
                    }
                }
                ocrWidth = (Int)((Float)width * zoomRate);
                ocrHeight = (Int
                    )((Float)height * zoomRate);
            }
        }
        mOcrSize.width = ocrWidth;
        mOcrSize.height = ocrHeight;
    }
}
