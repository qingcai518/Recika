//
//  DynamicChainData.swift
//  Recika
//
//  Created by liqc on 2018/10/24.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DynamicChainData {
    let id : String
    let headBlockNumber: Int
    let headBlockId : String
    let time: String
    let currentWitness : String
    let nextMaintenanceTime : String
    let lastBudgetTime : String
    let witnessBudget: Int
    let accountsRegisteredThisInterval: Int
    let recentlyMissedCount: Int
    let currentAslot: Int
    let recentSlotsFilled: String
    let dynamicFlags : Bool
    let lastIrreversiblkeBlockNum: Int
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.headBlockNumber = json["head_block_number"].intValue
        self.headBlockId = json["head_block_id"].stringValue
        self.time = json["time"].stringValue
        self.currentWitness = json["current_witness"].stringValue
        self.nextMaintenanceTime = json["next_maintenance_time"].stringValue
        self.lastBudgetTime = json["last_budget_time"].stringValue
        self.witnessBudget = json["witness_budget"].intValue
        self.accountsRegisteredThisInterval = json["accounts_registered_this_interval"].intValue
        self.recentlyMissedCount = json["recently_missed_count"].intValue
        self.currentAslot = json["current_aslot"].intValue
        self.recentSlotsFilled = json["recent_slots_filled"].stringValue
        self.dynamicFlags = json["dynamic_flags"].boolValue
        self.lastIrreversiblkeBlockNum = json["last_irreversible_block_num"].intValue
    }
}
