//
//  AnalyzeResultViewModel.swift
//  Recika
//
//  Created by liqc on 2018/09/18.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AnalyzeResultViewModel {
    func saveReceiptData(imgData: Data?, receiptAt: String?, tel: String?, totalPrice: String?, adjustPrice: String?, items:[AnalyzerItemInfo]?, completion: @escaping (String?) -> Void) {
        guard let addReceiptURL = URLComponents(string: addReceiptAPI) else {return completion("fail to get receipt API")}
        guard let imgData = imgData else {return completion("fail to get image data")}
        
        /// upload image.
        guard let imageData = UIImage(data: imgData)?.jpegData(compressionQuality: 0.25) else {
            return completion("fail to compress image data")
        }
        
        let headers = ["Content-Type": "application/json"]
        let imageName = UUID().uuidString
        SVProgressHUD.show(withStatus: "uploading recipt image.")
        Alamofire.upload(multipartFormData: { formData in
            formData.append(imageData, withName: "file", fileName: "\(imageName).jpg", mimeType: "image/jpeg")
        }, to: uploadDomain) { result in
            switch result {
            case .failure(let error):
                SVProgressHUD.dismiss()
                return completion(error.localizedDescription)
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { progress in
                    let completed = progress.completedUnitCount
                    let total = progress.totalUnitCount
                    print("total = \(total), completed = \(completed)")
                })
                
                upload.responseJSON() { response in
                    if let error = response.error {
                        SVProgressHUD.dismiss()
                        return completion(error.localizedDescription)
                    }
                    
                    guard let data = response.data else {
                        SVProgressHUD.dismiss()
                        return completion("fail to get upload ")
                    }
                    
                    let json = JSON(data)
                    let imagePath = json["imageURL"].stringValue
                    print(imagePath)
                    
                    /// 保存receipt信息.
                    var paramItems = [Any]()
                    if let items = items {
                        for item in items {
                            guard let name = item.name else {continue}
                            let itemName = name.takeUnretainedValue() as String
                            let itemPrice = item.price
                            let itemObj: [String: Any] = [
                                "name": itemName,
                                "price": itemPrice
                            ]
                            paramItems.append(itemObj)
                        }
                    }
                    
                    var params : [String: Any] = [
                        "user_id": userName,
                        "image_path": imagePath
                    ]
                    
                    if let receiptAt = receiptAt {
                        params["receipt_at"] = receiptAt
                    }
                    if let tel = tel {
                        params["tel"] = tel
                    }
                    if let totalPrice = totalPrice {
                        params["total_price"] = totalPrice
                    }
                    if let adjustPrice = adjustPrice {
                        params["adjust_price"] = adjustPrice
                    }
                    if paramItems.count > 0 {
                        params["items"] = paramItems
                    }
                    
                    SVProgressHUD.show(withStatus: "saving receipt data")
                    Alamofire.request(addReceiptURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                        SVProgressHUD.dismiss()
                        if let error = response.error {
                            return completion(error.localizedDescription)
                        }
                        
                        guard let data = response.data else {
                            return completion("fail to get data")
                        }
                        
                        let json = JSON(data)
                        let receiptId = json["receipt_id"].intValue
                        let itemDatas = json["items"].arrayValue.map{ItemData(json: $0)}
                        
                        let receiptData = ReceiptData(id: receiptId, imagePath: imagePath, hash: nil, tel: tel, receiptAt: receiptAt, totalPrice: totalPrice, adjustPrice: adjustPrice, items: itemDatas)
                        print(receiptData)
                        NotificationCenter.default.post(name: NFKey.saveReceipt, object: nil, userInfo: ["receipt_data": receiptData])
                        return completion(nil)
                    }
                }
            }
        }
    }
}
