//
//  PairController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class PairController: ViewController {
    var tabView : UICollectionView!
    lazy var current = UIView()
    let viewModel = PairViewModel()

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
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 64, height: 44)
        
        print(self.view.frame)
        
        let navi = naviheight(self.navigationController)
        let tab = tabHeight(self.tabBarController)
        
        let frame = CGRect(x: 0, y: navi + safeArea.top, width: screenWidth, height: 44)
        tabView = UICollectionView(frame: frame, collectionViewLayout: layout)
        tabView.backgroundColor = UIColor.white
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(PairTabCell.self, forCellWithReuseIdentifier: PairTabCell.id)
        self.view.addSubview(tabView)
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: tabView.frame.maxY, width: screenWidth, height: screenHeight - tab - tabView.frame.maxY)
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width: screenWidth * CGFloat(viewModel.titles.count), height: scrollView.frame.height)
        self.view.addSubview(scrollView)
        
        let dummyColor = [UIColor.orange, UIColor.blue, UIColor.yellow, UIColor.green]
        
        for i in 0..<viewModel.titles.count {
            let title = viewModel.titles[i]
            let tableView = UITableView()
            tableView.backgroundColor = dummyColor[i]
            tableView.frame = CGRect(x: CGFloat(i) * screenWidth, y: 0, width: screenWidth, height: scrollView.frame.height)
            scrollView.addSubview(tableView)
        }
    }
}

extension PairController : UICollectionViewDelegate {
    
}

extension PairController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PairTabCell.id, for: indexPath) as! PairTabCell
        let title = viewModel.titles[indexPath.item]
        let isSelected = viewModel.selected == indexPath.item
        cell.configure(with: title, isSelected: isSelected)
        return cell
    }
}

extension PairController: UITableViewDelegate {
    
}

