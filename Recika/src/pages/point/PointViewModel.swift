//
//  PointViewModel.swift
//  Recika
//
//  Created by liqc on 2018/10/18.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

class PointViewModel {
    let points = [
        PointData(symbol: RecikaPoint, name: RecikaPointName, rate: 1, logo: recikaIcon),
        PointData(symbol: BPoint, name: BPointName, rate: BPT_RCP, logo: bpointIcon),
        PointData(symbol: DPoint, name: DPointName, rate: DPT_RCP, logo: dpointIcon)
    ]
}
