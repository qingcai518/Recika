//
//  ResultController.swift
//  Recika
//
//  Created by liqc on 2018/09/13.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ResultController: ViewController {
    let tableView = UITableView()
    let topView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setupSubViews() {
        view.addSubview(topView)
        view.addSubview(tableView)
    }
}
