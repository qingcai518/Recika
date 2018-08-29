//
//  SettingController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class SettingController: ViewController {
    let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), style: .grouped)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingType1Cell.self, forCellReuseIdentifier: SettingType1Cell.id)
        tableView.register(SettingType2Cell.self, forCellReuseIdentifier: SettingType2Cell.id)
        view.addSubview(tableView)
    }
}

extension SettingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = viewModel.settings[indexPath.section][indexPath.row]
        if data.title == "ログアウト" {
            let alert = UIAlertController(title: "ログアウト", message: "ログアウトします、よろしいでしょうか？", preferredStyle: .actionSheet)
            let sheet1 = UIAlertAction(title: "はい", style: .destructive) { action in
                clearUser()
                print("do logout here")
                UIApplication.shared.keyWindow?.rootViewController = LoginController()
            }
            let sheet2 = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
            alert.addAction(sheet1)
            alert.addAction(sheet2)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SettingController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settings[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.settings[indexPath.section][indexPath.row]
        if data.detail == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingType2Cell.id, for: indexPath) as! SettingType2Cell
            cell.configure(with: data)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingType1Cell.id, for: indexPath) as! SettingType1Cell
            cell.configure(with: data)
            return cell
        }
    }
}
