//
//  ReceiptController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class ReceiptController: ViewController {
    var collectionView : UICollectionView!
    let viewModel = ReceiptViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        view.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        let width = (screenWidth - 3 * 10) / 2
        let height = width * 5 / 3
        layout.itemSize = CGSize(width: width, height: height)
        let rect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ReceiptCell.self, forCellWithReuseIdentifier: ReceiptCell.id)
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
