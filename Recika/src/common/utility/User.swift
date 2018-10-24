//
//  User.swift
//  Recika
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

//let userName: String = UserDefaults.standard.string(forKey: UDKey.userName) == nil ? "" : UserDefaults.standard.string(forKey: UDKey.userName)!
//let ownerPubKey: String = UserDefaults.standard.string(forKey: UDKey.ownerPubKey) == nil ? "" : UserDefaults.standard.string(forKey: UDKey.ownerPubKey)!
//let activePubKey: String = UserDefaults.standard.string(forKey: UDKey.activePubKey) == nil ? "" : UserDefaults.standard.string(forKey: UDKey.activePubKey)!
//let memoPubKey: String = UserDefaults.standard.string(forKey: UDKey.memoPubKey) == nil ? "" : UserDefaults.standard.string(forKey: UDKey.ownerPubKey)!

var userName : String {
    if let name = UserDefaults.standard.string(forKey: UDKey.userName) {
        return name
    }
    return ""
}

var ownerPubKey : String {
    if let ownerPubKey = UserDefaults.standard.string(forKey: UDKey.ownerPubKey) {
        return ownerPubKey
    }
    return ""
}

var activePubKey: String {
    if let activePubKey = UserDefaults.standard.string(forKey: UDKey.activePubKey) {
        return activePubKey
    }
    return ""
}

var memoPubKey: String {
    if let memoPubKey = UserDefaults.standard.string(forKey: UDKey.memoPubKey) {
        return memoPubKey
    }
    return ""
}

func saveUser(name: String, ownerKey: String?, activeKey: String?, memoKey: String?) {
    UserDefaults.standard.set(name, forKey: UDKey.userName)
    UserDefaults.standard.set(ownerKey, forKey: UDKey.ownerPubKey)
    UserDefaults.standard.set(activeKey, forKey: UDKey.activePubKey)
    UserDefaults.standard.set(memoKey, forKey: UDKey.memoPubKey)
    UserDefaults.standard.set(true, forKey: UDKey.isLogin)
    UserDefaults.standard.synchronize()
}

func clearUser() {
    UserDefaults.standard.removeObject(forKey: UDKey.userName)
    UserDefaults.standard.removeObject(forKey: UDKey.ownerPubKey)
    UserDefaults.standard.removeObject(forKey: UDKey.activePubKey)
    UserDefaults.standard.removeObject(forKey: UDKey.memoPubKey)
    UserDefaults.standard.removeObject(forKey: UDKey.isLogin)
    UserDefaults.standard.synchronize()
}
