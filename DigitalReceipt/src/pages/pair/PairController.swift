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
        
        tabView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        tabView.backgroundColor = UIColor.clear
        view.addSubview(tabView)
        
        tabView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(PairTabCell.self, forCellWithReuseIdentifier: PairTabCell.id)
        
        // set line view.
        let lineView = UIView(frame: CGRect.zero)
        lineView.backgroundColor = UIColor.lightGray
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(tabView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        // set current View
        current.backgroundColor = UIColor.red
        view.addSubview(current)
        current.snp.makeConstraints { make in
            make.top.equalTo(tabView.snp.bottom).offset(-1)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(2)
            make.width.equalTo(20)
        }
        
        // add contentView
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(current.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        print("scroll view frame = \(scrollView.frame)")
        
//        scrollView.contentSize = CGSize(width: CGFloat(viewModel.titles.count) * scrollView.frame.width, height: scrollView.frame.height)
        scrollView.backgroundColor = UIColor.yellow
        scrollView.contentSize = CGSize(width: CGFloat(viewModel.titles.count) * screenWidth, height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        let dummy = [UIColor.white, UIColor.red, UIColor.blue, UIColor.green]
        
        for i in 0..<viewModel.titles.count {
            let title = viewModel.titles[i]
            let tableView = UITableView()
            tableView.frame = CGRect(x: CGFloat(i) * screenWidth, y: 0, width: screenWidth, height: 200)
//            tableView.frame = CGRect(x: CGFloat(i) * screenWidth, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            tableView.backgroundColor = dummy[i]
//            tableView.delegate = self
//            tableView.dataSource = self
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

//extension PairController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.tables[indexPath.item]
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: self, for: indexPath)
//        let ata = viewModel.data[indexPath.item]
//        cell.configure(with: data)
//        return cell
//    }
//}
