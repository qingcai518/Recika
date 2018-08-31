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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        view.backgroundColor = UIColor.white
        
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        let width = (screenWidth - 3 * 10) / 2
        let height 
        layout.itemSize = CGSize(width: width, height: )
        collectionView = UICollectionView(frame: , collectionViewLayout: <#T##UICollectionViewLayout#>)
    }
}
