//
//  ExchangeConfirmViewModel.swift
//  Recika
//
//  Created by liqc on 2018/10/10.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ExchangeConfirmViewModel {
    
//    func doExchange(count: Double, rateData: RateData, completion: @escaping Callback) {
//        let blockNum: Int32 = 0
//        let blockId = "1"
//        let expiration = Date().timeIntervalSince1970 + 3600 * 10   // 交易到期时间 10分钟之后
//        let chainId = "123"
//        let userId: Int32 = 1
//        let orderExpirtion = Date().timeIntervalSince1970 + 3600 * 24 * 365    // 挂单1年之后过期
//        let asseetId: Int32 = 1
//        let amount: Int64 = 123
//        let receiveAssetId: Int32 = 2
//        let receiveAmount: Int64 = 321
//        let feeId: Int32 = 3
//        let feeAmount: Int64 = 321
//        guard let jsonStr = BitShareCoordinator.getLimitOrder(blockNum, block_id: blockId, expiration: expiration, chain_id: chainId, user_id: userId, order_expiration: orderExpiration, asset_id: asseetId, amount: amount, receive_asset_id: receiveAssetId, receive_amount: receiveAmount, fee_id: feeId, fee_amount: feeAmount) else {
//            return completion("fail to get limit order")
//        }
//        
//        print("json string = \(jsonStr)")
//        return completion(nil)
//    }
    
    func doExchange(count: Double, rateData: RateData, completion:@escaping (String?) -> Void) {
        guard let api = URLComponents(string: orderAPI) else {return}
        let params: [String: Any] = [
            "user_id": userName,
            "from_symbol": rateData.baseSymbol,
            "to_symbol": rateData.targetSymbol,
            "from_count": count * rateData.rate,
            "to_count": count
        ]
        
        let headers = [
            "Content-type": "application/json"
        ]
        SVProgressHUD.show()
        Alamofire.request(api, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SVProgressHUD.dismiss()
            if let error = response.error {
                return completion(error.localizedDescription)
            }
            guard let data = response.data else {
                return completion("fail to get data.")
            }
            
            let json = JSON(data)
            print(json)
            return completion(nil)
        }
    }
}
