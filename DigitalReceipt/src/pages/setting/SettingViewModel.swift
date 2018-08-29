//
//  SettingViewModel.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import Foundation

class SettingViewModel {
    let settings = [
        [
            SettingData(title: "会員カード連携", detail: "お店の会員カード提示でレシートがアプリに届きます"),
            SettingData(title: "マイストア", detail: "登録するとお得な情報が届きます"),
            SettingData(title: "登録情報", detail: "ログインに使うメールアドレスや携帯番号編集はこちらから")
        ],
        [
            SettingData(title: "通知設定", detail: "アプリやメールでの通知のオンオフはこちらから"),
            SettingData(title: "パスコードロック", detail: "レシート画面などにロックをかけることができます"),
            SettingData(title: "レシートデータ出力", detail: "表計算ソフトに取り込める形式に出力します")
        ],
        [
            SettingData(title: "使えるお店一覧", detail: ""),
            SettingData(title: "スマートレシートからのご案内", detail: "")
        ],
        [
            SettingData(title: "使い方", detail: ""),
            SettingData(title: "よくあるお問い合わせ", detail: ""),
            SettingData(title: "スマートレシートについて", detail: ""),
            SettingData(title: "機種変更について", detail: "")
        ],
        [
            SettingData(title: "利用規約", detail: ""),
            SettingData(title: "運営会社情報", detail: "")
        ],
        [
            SettingData(title: "ログアウト", detail: "")
        ]
    ]
}
