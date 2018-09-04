
//
//  PairViewMode3l.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import RxSwift

class PairViewModel {
    var selected = Variable(0)
    let titles = [
        PairTabData(title: "USDT", isSelected: true),
        PairTabData(title: "BTC", isSelected: false),
        PairTabData(title: "ETH", isSelected: false),
        PairTabData(title: "CYB", isSelected: false)
    ]
}
