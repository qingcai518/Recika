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
    let viewModel = ReceiptDetailViewModel()
    
    // param
    var receiptData: ReceiptData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubView()
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubView() {
        tableView.register(ReceiptDetailCell.self, forCellReuseIdentifier: ReceiptDetailCell.id)
        tableView.register(ReceiptItemCell.self, forCellReuseIdentifier: ReceiptDetailCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.items.asObservable().bind { [weak self] _ in
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension ReceiptDetailController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ReceiptDetailController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptDetailCell.id, for: indexPath) as! ReceiptDetailCell
            if let receiptData = receiptData {
                cell.configure(with: receiptData)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptItemCell.id, for: indexPath) as! ReceiptItemCell
            let item = viewModel.items.value[indexPath.item]
            cell.configure(with: item)
            return cell
        }
    }
}
