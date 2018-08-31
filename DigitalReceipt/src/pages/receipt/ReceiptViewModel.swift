//
//  ReceiptViewModel.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/30.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

class ReceiptViewModel {
    var receipts = [ReceiptData]()
    
    func getReceipts() {
        let item1 = ItemData(id: 1, name: "Item001", price: 100, count: 1)
        let item2 = ItemData(id: 2, name: "Item002", price: 200, count: 1)
        let item3 = ItemData(id: 3, name: "Item003", price: 300, count: 2)
        let item4 = ItemData(id: 4, name: "Item004", price: 400, count: 1)
        let item5 = ItemData(id: 5, name: "Item005", price: 500, count: 2)
        
        let receipt1 = ReceiptData(id: 1, name: "Receipt001", time: "2018-08-31 12:3-0:30", items: [item1, item2], totalPrice: 200)
        let receipt2 = ReceiptData(id: 2, name: "Receipt002", time: "2018-09-01 12:3-0:30", items: [item1, item2, item3], totalPrice: 300)
        let receipt3 = ReceiptData(id: 3, name: "Receipt003", time: "2018-09-02 12:3-0:30", items: [item1, item2, item4], totalPrice: 400)
        let receipt4 = ReceiptData(id: 4, name: "Receipt004", time: "2018-09-03 12:3-0:30", items: [item1, item5], totalPrice: 500)
        let receipt5 = ReceiptData(id: 5, name: "Receipt005", time: "2018-09-04 12:3-0:30", items: [item2], totalPrice: 600)
        let receipt6 = ReceiptData(id: 6, name: "Receipt006", time: "2018-09-05 12:3-0:30", items: [item2, item3, item4], totalPrice: 700)
        let receipt7 = ReceiptData(id: 7, name: "Receipt007", time: "2018-09-06 12:3-0:30", items: [item1, item4], totalPrice: 800)
        let receipt8 = ReceiptData(id: 8, name: "Receipt008", time: "2018-09-08 12:3-0:30", items: [item1, item5], totalPrice: 900)
        let receipt9 = ReceiptData(id: 9, name: "Receipt009", time: "2018-09-09 12:3-0:30", items: [item3], totalPrice: 1000)
        let receipt10 = ReceiptData(id: 10, name: "Receipt010", time: "2018-09-10 12:3-0:30", items: [item3, item5], totalPrice: 1300)
        let receipt11 = ReceiptData(id: 11, name: "Receipt011", time: "2018-09-11 12:3-0:30", items: [item4, item5], totalPrice: 200)
        receipts = [
            receipt1,
            receipt2,
            receipt3,
            receipt4,
            receipt5,
            receipt6,
            receipt7,
            receipt8,
            receipt9,
            receipt10,
            receipt11
        ]
    }
}
