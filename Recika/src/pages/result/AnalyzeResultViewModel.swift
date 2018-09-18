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
        guard let receiptURL = URLComponents(string: receiptAPI) else {return completion("fail to get receipt API")}
        guard let itemURL = URLComponents(string: itemAPI) else {return completion("fail to get item API")}
        guard let imgData = imgData else {return completion("fail to get image data")}
        guard let receiptAt = receiptAt else {return completion("have no receiptAt")}
        guard let tel = tel else {return completion("have no tel")}
        guard let totalPrice = totalPrice else {return completion("have no total price")}
        guard let adjustPrice = adjustPrice else {return completion("have no adjust price")}
        guard let items = items else {return completion("have not items")}
        
        /// upload image.
        guard let image = UIImage(data: imgData), let imageData = UIImageJPEGRepresentation(image, 0.25) else {
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
                    let group = DispatchGroup()
                    let params: [String: Any] = [
                        "ReceiptAt" : receiptAt,
                        "Tel": tel,
                        "TotalPrice": totalPrice,
                        "AdjustPrice": adjustPrice
                    ]
                    
                    SVProgressHUD.show(withStatus: "saving receipt basic data.")
                    print(params)
                    print(receiptURL.url?.absoluteString)
                    Alamofire.request(receiptURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                        if let error = response.error {
                            SVProgressHUD.dismiss()
                            return completion(error.localizedDescription)
                        }
                        guard let data = response.data else {
                            SVProgressHUD.dismiss()
                            return completion("fail to get data")
                        }
                        
                        let json = JSON(data)
                        print(json)
                        let receiptId = json["ReceiptId"].intValue
                        
                        SVProgressHUD.show(withStatus: "saving receipt detail data.")
                        for i in 0..<items.count {
                            let item = items[i]
                            guard let name = item.name else {continue}
                            let itemName = name.takeUnretainedValue() as String
                            let price = item.price
                            let itemParams:[String: Any] = [
                                "receiptId": receiptId,
                                "name": itemName,
                                "price": price
                            ]
                            
                            group.enter()
                            DispatchQueue(label: "item\(i)").async(group: group) {
                                Alamofire.request(itemURL, method: .post, parameters: itemParams, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                                    if let error = response.error {
                                        SVProgressHUD.dismiss()
                                        return completion(error.localizedDescription)
                                    }
                                    
                                    guard let data = response.data else {
                                        SVProgressHUD.dismiss()
                                        return completion("fail to get data")
                                    }
                                    
                                    let json = JSON(data)
                                    print(json)
                                    group.leave()
                                }
                            }
                        }
                        
                        group.notify(queue: .main, execute: {
                            SVProgressHUD.dismiss()
                            return completion(nil)
                        })
                    }
                }
            }
        }
    }
}