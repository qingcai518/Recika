//
//  KeyData.swift
//  Recika
//
//  Created by liqc on 2018/10/24.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct KeysData {
    let activeKey: KeyData
    let ownerKey: KeyData
    let memoKey: KeyData
    
    init(_ json: JSON) {
        let activeData = json["active-key"]
        let ownerData = json["owner-key"]
        let memoData = json["memo-key"]
        
        print("active = \(activeData)")
        print("owner = \(ownerData)")
        print("memo = \(memoData)")
        
        self.activeKey = KeyData(activeData)
        self.ownerKey = KeyData(ownerData)
        self.memoKey = KeyData(memoData)
    }
}

struct KeyData {
    let privateKey : String
    let publicKey: String
    let address : String
    let compressed: String
    let uncompressed: String
    
    init(_ json: JSON) {
        self.privateKey = json["private_key"].stringValue
        self.publicKey = json["public_key"].stringValue
        self.address = json["address"].stringValue
        self.compressed = json["compressed"].stringValue
        self.uncompressed = json["uncompressed"].stringValue
    }
}
