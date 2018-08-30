//
//  NetConstants.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/28.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

// api domain.
let cybexDomain = "http://localhost:8081"
let domain = "http://localhost:8080"

// api version
let v1 = "/v1/"

// ユーザー登録API (Python API)
let signupAPI = cybexDomain + v1 + "signup"

// ユーザーbalance取得.
let balanceAPI = cybexDomain + v1 + "balance"

// ユーザー
let userAPI = domain + v1 + "user/"
let loginAPI = userAPI + "login"

// 商品.
let giftAPI = domain + v1 + "gift/"
