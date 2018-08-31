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
        let item 1 = ItemData(id: 1, name: "Item001", price: 100, count: 1)
        let item 2 = ItemData(id: 2, name: "Item001", price: 100, count: 1)
        let item 3 = ItemData(id: 3, name: "Item001", price: 100, count: 1)
        let item 4 = ItemData(id: 4, name: "Item001", price: 100, count: 1)
        let item 5 = ItemData(id: 5, name: "Item001", price: 100, count: 1)
        
        let receipt = ReceiptData(id: 1, name: <#T##String#>, time: <#T##String#>, items: <#T##[ItemData]#>, totalPrice: <#T##Double#>)
    }
}
