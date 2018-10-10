//
//  ExchangeViewModel.swift
//  Recika
//
//  Created by liqc on 2018/10/10.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

class ExchangeViewModel {
    var rates = [RateData]()
    
    func getRates() {
        let rateData = RateData(name: "Rate", rate: 0.1)
        let rateData2 = RateData(name: "rate", rate: 0.2)
    }
}
