//
//  NetConstants.swift
//  Recika
//
//  Created by liqc on 2018/08/28.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

// api domain.
//let cybexDomain = "http://localhost:8081"
let cybexDomain = "http://47.91.242.71:8088"
let domain = "http://localhost:8080"

// api version
let v1 = "/v1/"

// ユーザー登録API (Python API)
let signupAPI = cybexDomain + v1 + "signup"

// ユーザーbalance取得.
let balanceAPI = cybexDomain + v1 + "balance"

// Cybexアカウントと関連する
let associateAPI = cybexDomain + v1 + "associate"

// ユーザー
let userAPI = domain + v1 + "user/"
let loginAPI = userAPI + "login"

// 商品.
let giftAPI = domain + v1 + "gift/"

// get pairs.
let pairsAPI = "https://app.cybex.io/lab/exchange/asset"
//let pairsAPI = cybexDomain + v1 + "pairs"

// 获取最新的交易信息.
let tickerAPI = cybexDomain + v1 + "ticker"

// 获取24小时涨幅.
let changeAPI = cybexDomain + v1 + "change"

// 获取K线信息.
let klineAPI = cybexDomain + v1 + "market"

// 发票信息.
let receiptAPI = domain + v1 + "receipt/"

// 发票详细信息
let itemAPI = domain + v1 + "item/"

