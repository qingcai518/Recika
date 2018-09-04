//
//  PairTabData.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/04.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import RxSwift

struct PairData {
    let title: String
    var selected = Variable(false)
    var prices = [PriceData]()
    
    init(title: String, isSelected: Bool = false) {
        self.title = title
        self.selected.value = isSelected
    }
}