//
//  GiftController.swift
//  Recika
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import ESPullToRefresh

class GiftController: ViewController {
    var collectionView: UICollectionView!
    let viewModel = GiftViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setSubViews()
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        let layout = UICollectionViewFlowLayout()
        let margin: CGFloat = 2
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: margin, right: margin)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        let width = (screenWidth - 4 * margin) / 3
        layout.itemSize = CGSize(width: width, height: width)
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(GiftCell.self, forCellWithReuseIdentifier: GiftCell.id)
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        
        // add pull header and footer.
        collectionView.es.addPullToRefresh { [weak self] in
            self?.getData()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    private func getData() {
        viewModel.getGifts { [weak self] msg in
            self?.collectionView.es.stopPullToRefresh()
            
            if let msg = msg {
                self?.showToast(text: msg)
            } else {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension GiftController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let gift = viewModel.gifts[indexPath.item]
        let next = DetailController()
        self.navigationController?.pushViewController(next, animated: true)
        next.setParam(data: gift)
    }
}

extension GiftController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.gifts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftCell.id, for: indexPath) as! GiftCell
        let data = viewModel.gifts[indexPath.item]
        cell.configure(with: data)
        return cell
    }
}
