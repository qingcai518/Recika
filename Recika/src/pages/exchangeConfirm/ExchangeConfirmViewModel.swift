//
//  ExchangeConfirmViewModel.swift
//  Recika
//
//  Created by liqc on 2018/10/10.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

class ExchangeConfirmViewModel {
    func doExchange(count: Double, rateData: RateData) {
        let base = rateData.baseName
        let target = rateData.targetName
        
        print("exchange from: [\(base)],   to [\(target)],  count = \(count)")
    }
}
