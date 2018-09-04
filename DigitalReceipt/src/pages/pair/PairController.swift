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
    lazy var contentView = UIScrollView()
    lazy var current = UIView()
    let viewModel = PairViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
        getData()
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
        
        let navi = naviheight(self.navigationController)
        let tab = tabHeight(self.tabBarController)
        
        let frame = CGRect(x: 0, y: navi + safeArea.top, width: screenWidth, height: 44)
        tabView = UICollectionView(frame: frame, collectionViewLayout: layout)
        tabView.backgroundColor = UIColor.white
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(PairTabCell.self, forCellWithReuseIdentifier: PairTabCell.id)
        self.view.addSubview(tabView)
        
        // line
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        line.frame = CGRect(x: 0, y: tabView.frame.maxY, width: screenWidth, height: 1)
        self.view.addSubview(line)
        
        // current View.
        current.backgroundColor = UIColor.red
        current.frame = CGRect(x: 0, y: line.frame.minY - 1, width: 64, height: 2)
        self.view.addSubview(current)
        
        contentView.frame = CGRect(x: 0, y: tabView.frame.maxY, width: screenWidth, height: screenHeight - tab - tabView.frame.maxY)
        contentView.isPagingEnabled = true
        contentView.backgroundColor = UIColor.white
        contentView.contentSize = CGSize(width: screenWidth * CGFloat(viewModel.titles.count), height: contentView.frame.height)
        contentView.delegate = self
        self.view.addSubview(contentView)
        
        for i in 0..<viewModel.titles.count {
            let tableView = UITableView()
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.frame = CGRect(x: CGFloat(i) * screenWidth, y: 0, width: screenWidth, height: contentView.frame.height)
            tableView.register(PriceCell.self, forCellReuseIdentifier: PriceCell.id)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.tag = i
            contentView.addSubview(tableView)
        }
    }
    
    private func getData() {
        viewModel.getPairs { [weak self] msg in
            if let msg = msg {
                self?.showToast(text: msg)
            } else {
                self?.tabView.reloadData()
                let _ = self?.contentView.subviews.filter{$0.isKind(of: UITableView.self)}.map{$0 as? UITableView}.map{$0?.reloadData()}
            }
        }
    }
    
    fileprivate func resetSelection(index: Int) {
        let _ = viewModel.titles.map{$0.selected.value = false}
        viewModel.titles[index].selected.value = true
    }
}

extension PairController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        resetSelection(index: indexPath.item)
        contentView.scrollToPage(indexPath.item)
    }
}

extension PairController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PairTabCell.id, for: indexPath) as! PairTabCell
        let data = viewModel.titles[indexPath.item]
        cell.configure(with: data)
        return cell
    }
}

extension PairController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PairController: UITableViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PriceCell.id, for: indexPath) as! PriceCell
        let title = viewModel.titles[tableView.tag]
        print(title)
        let price = title.prices[indexPath.item]
        print(price)
        cell.configure(with: price)
        return cell
    }
}


extension PairController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.contentView {return}
        let offset = scrollView.contentOffset.x
        
        // 现在选择的位置.
        let page = Int(offset / screenWidth)
        
        // 选择位置移动.
        let originX = 64 * offset / screenWidth
        current.frame.origin.x = originX
        
        // 颜色.
        resetSelection(index: page)
    }
}
