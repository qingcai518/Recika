//
//  HomeViewModel.swift
//  Recika
//
//  Created by liqc on 2018/08/30.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class HomeViewModel {
    var points =[PointData]()
    var balance = Variable("-")
    var timer: Timer?
    
    private func getBalance() {
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
    
    func startGetBalance() {
        getBalance()
        stopGetBalance()
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { [weak self] _ in
            self?.getBalance()
        })
    }
    
    func stopGetBalance() {
        timer?.invalidate()
        timer = nil
    }
    
    func getMyPoints(completion: @escaping ()-> Void) {
        let point1 = PointData(name: "Bitcoin", count: 100, baseCount: 20)
        let point2 = PointData(name: "Ethereum", count: 200, baseCount: 30)
        let point3 = PointData(name: "ERO", count : 44, baseCount: 20)
        
        self.points = [point1, point2, point3]
        return completion()
    }
}
