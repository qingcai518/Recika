//
//  HomeViewModel.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/30.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class HomeViewModel {
    var balance = Variable("-")
    
    func getBalance() {
        // 一時的にpython apiを利用して取得する。将来go apiに切り替える.
        let url = balanceAPI + "?name=\(userName)&symbol=\(symbol)"
        guard let api = URLComponents(string: url) else{return}
        
        Alamofire.request(api, method: .get).responseJSON { response in
            if let error = response.error {
                print(error.localizedDescription)
                return
            }
            guard let data = response.data else {return}
            let json = JSON(data)
            print(json)
            let amount = json["amount"].stringValue
            if amount != "" {
                self.balance.value = amount
            }
        }
    }
}
