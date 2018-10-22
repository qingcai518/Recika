//
//  PointController.swift
//  Recika
//
//  Created by liqc on 2018/10/18.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SnapKit

class PointController: ViewController {
    let tableView = UITableView()
    let viewModel = PointViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
    }
    
    private func setSubviews() {
        // backgroundColor.
        self.view.backgroundColor = UIColor.white
        
        // right button.
        let chartBtn = UIButton()
        chartBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        chartBtn.setImage(chart, for: .normal)
        
        let rightItem = UIBarButtonItem(customView: chartBtn)
        navigationItem.rightBarButtonItem = rightItem
        
        chartBtn.rx.tap.bind { [weak self] sender in
            let next = PairController()
            let navi = UINavigationController(rootViewController: next)
            self?.present(navi, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        // tableview.
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 112
        tableView.register(PointCell.self, forCellReuseIdentifier: PointCell.id)
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension PointController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let next = UIViewController()
        next.view.backgroundColor = UIColor.yellow
        self.navigationController?.pushViewController(next, animated: true)
    }
}

extension PointController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PointCell.id, for: indexPath) as! PointCell
        let data = viewModel.points[indexPath.row]
        cell.configure(with: data)
        return cell
    }
}
