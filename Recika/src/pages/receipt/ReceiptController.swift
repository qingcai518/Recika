//
//  ReceiptController.swift
//  Recika
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import RxSwift

class ReceiptController: ViewController {
    var collectionView: UICollectionView!
    let viewModel = ReceiptViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
        getData()
        addListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        view.backgroundColor = UIColor.white
        
        // title button.
        let scanBtn = UIButton(type: .custom)
        scanBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        scanBtn.setImage(scanIcon, for: .normal)
        let barItem = UIBarButtonItem(customView: scanBtn)
        navigationItem.rightBarButtonItems = [barItem]
        
        scanBtn.rx.tap.bind { [weak self] in
            let navigation = UINavigationController()
            navigation.viewControllers = [ScanController()]
            self?.present(navigation, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(12, 10, 12, 10)
        let width = (screenWidth - 3 * 10) / 2
        let height = width * 5 / 3
        layout.itemSize = CGSize(width: width, height: height)
        let rect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ReceiptCell.self, forCellWithReuseIdentifier: ReceiptCell.id)
    }
    
    private func getData() {
        viewModel.getReceiptData { [weak self] msg in
            if let msg = msg {
                self?.showToast(text: msg)
            } else {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func addListener() {
        NotificationCenter.default.rx.notification(NFKey.saveReceipt).bind { [weak self] sender in
            guard let info = sender.userInfo else {return}
            print("info \(info)")
            guard let receiptData = info["receipt_data"] as? ReceiptData else {return}
            self?.viewModel.receipts.insert(receiptData, at: 0)
            self?.collectionView.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension ReceiptController : UICollectionViewDelegate {
    
}

extension ReceiptController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.receipts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReceiptCell.id, for: indexPath) as! ReceiptCell
        let data = viewModel.receipts[indexPath.row]
        cell.configure(with: data)
        return cell
    }
}
