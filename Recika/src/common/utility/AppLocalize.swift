//
//  AppLocalize.swift
//  Recika
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

let str_home = NSLocalizedString("home", comment: "")
let str_receipt = NSLocalizedString("receipt", comment: "")
let str_chart = NSLocalizedString("chart", comment: "")
let str_gift = NSLocalizedString("gift", comment: "")
let str_setting = NSLocalizedString("setting", comment: "")
let str_login = NSLocalizedString("login", comment: "")
let str_signup = NSLocalizedString("signup", comment: "")
let str_name = NSLocalizedString("name", comment: "")
let str_email = NSLocalizedString("email", comment: "")
let str_password = NSLocalizedString("password", comment: "")
let str_associate = NSLocalizedString("associate", comment: "")
let str_cancel = NSLocalizedString("cancel", comment: "")
let str_save = NSLocalizedString("save", comment: "")
let str_time = NSLocalizedString("time", comment: "")
let str_tel = NSLocalizedString("tel", comment: "")
let str_totalprice = NSLocalizedString("totalprice", comment: "")
let str_adjustprice = NSLocalizedString("adjustprice", comment: "")

// messages.
let msg1 = NSLocalizedString("msg1", comment: "")

func localize(key: String, arguments: CVarArg...) -> String {
    return String(format: NSLocalizedString(key, comment: ""), arguments)
}
