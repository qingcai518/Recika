//
//  ItemController.swift
//  Recika
//
//  Created by liqc on 2018/09/19.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ReceiptDetailController: ViewController {
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}
