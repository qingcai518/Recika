//
//  PairTabData.swift
//  Recika
//
//  Created by liqc on 2018/09/04.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import RxSwift

struct PairData {
    let tokenName : String
    var selected = Variable(false)
    var prices = [PriceData]()
    
    init(tokenName: String, isSelected: Bool = false) {
        self.tokenName = tokenName
        self.selected.value = isSelected
    }
}
