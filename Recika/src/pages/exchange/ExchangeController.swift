//
//  ExchangeController.swift
//  Recika
//
//  Created by liqc on 2018/10/09.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ExchangeController: ViewController {
    let tableView = UITableView()
    let baseLbl = UILabel()
    let targetLbl = UILabel()
    let viewModel = ExchangeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
    }
    
    private func setSubviews() {
        self.view.backgroundColor = UIColor.white
        self.title = str_exchange
        
        let closeBtn = UIButton()
        closeBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        closeBtn.setImage(close, for: .normal)
        
        let barItem = UIBarButtonItem(customView: closeBtn)
        self.navigationItem.rightBarButtonItem = barItem
        
        // add action.
        closeBtn.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        // set tableView.
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        tableView.backgroundColor = UIColor.clear
        
        //  set base and target.
        baseLbl.textColor = UIColor.black
        baseLbl.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(baseLbl)
        
        targetLbl
        .textColor = UIColor.black
        targetLbl.font = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(targetLbl)
        
        baseLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
        }
    }
}

extension ExchangeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ExchangeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeCell.id, for: indexPath) as! ExchangeCell
        let data = viewModel.rates[indexPath.item]
        cell.configure(with: data)
        return cell
    }
}
