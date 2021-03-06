//
//  NetConstants.swift
//  Recika
//
//  Created by liqc on 2018/08/28.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

// 区块链相关设定.
let AdminName = "zhuanzhi518"
let AdminUID = "1.2.4432"
let AdminMemoKey = "CYB8Qf1LCtL4u7BkAYp5g65yeQ1sHWwsdSKzmsbsu44UGvrYukfBB"
let BaseAsset = "CYB"

// bc tecth环境
// Python API.
let cybexDomain = "http://52.197.86.134:8081"
// Go API.
//let domain = "http://52.197.86.134:8085"
// Java API.
let domain = "http://52.197.86.134:8080"

let uploadDomain = "https://main-myreader.ssl-lolipop.jp/recika_upload"    // 暂时用

// api version
let v1 = "/v1/"

// ユーザー登録API (Python API)
let signupAPI = cybexDomain + v1 + "signup"

// 取得主流币种的balance.
let mainBalanceAPI = cybexDomain + v1 + "main_balance"

// ユーザーbalance取得.
let balanceAPI = cybexDomain + v1 + "balance"

// Cybexアカウントと関連する
let associateAPI = cybexDomain + v1 + "associate"

// ユーザー
let userAPI = domain + v1 + "user/"
let loginAPI = cybexDomain + v1 + "login"
let uidAPI = cybexDomain + v1 + "uid"

// 商品.
let giftAPI = domain + v1 + "gift/"

// get pairs.
let pairsAPI = cybexDomain + v1 + "pairs"

// 获取最新的交易信息.
let tickerAPI = cybexDomain + v1 + "ticker"

// 获取24小时涨幅.
let changeAPI = cybexDomain + v1 + "change"

// 获取K线信息.
let klineAPI = cybexDomain + v1 + "market"

// 登陆发票信息.
let addReceiptAPI = cybexDomain + v1 + "receipt/add"

// 获取发票信息.
let receiptAPI = domain + v1 + "receipt/"

// 获取发票上面的详细信息.
let itemAPI = domain + v1 + "item/"

// 暂时存在，挂单api
let orderAPI = cybexDomain + v1 + "order"

// 区块链动态信息.
let chainAPI = cybexDomain + v1 + "chain"

// 区块链id.
let chainIdAPI = cybexDomain + v1 + "chain_id"

// 获取资产信息
let assetsAPI = cybexDomain + v1 + "assets"

// 转账
let transferAPI = cybexDomain + v1 + "transfer"

// 广播
let broadcastAPI = cybexDomain + v1 + "broadcast"
