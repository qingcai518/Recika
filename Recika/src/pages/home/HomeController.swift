//
//  HomeController.swift
//  Recika
//
//  Created by liqc on 2018/08/22.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class HomeController: ViewController {
    var collectionView: UICollectionView!
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startGetBalance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopGetBalance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getData() {
        viewModel.points.asObservable().bind { [weak self] _ in
            self?.collectionView.reloadData()
        }.disposed(by: disposeBag)
        viewModel.startGetBalance()
    }
    
    private func setSubViews() {
        self.view.backgroundColor = UIColor.white
        
        let title1Lbl = UILabel()
        title1Lbl.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        title1Lbl.textColor = UIColor.lightGray
        title1Lbl.text = str_your_coin
        self.view.addSubview(title1Lbl)
        
        title1Lbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            make.left.right.equalTo(16)
        }
        
        let amountLbl = UILabel()
        amountLbl.font = UIFont.boldSystemFont(ofSize: 24)
        amountLbl.textColor = UIColor.black
        self.view.addSubview(amountLbl)
        viewModel.balance.asObservable().bind(to: amountLbl.rx.text).disposed(by: disposeBag)
        
        amountLbl.snp.makeConstraints { make in
            make.top.equalTo(title1Lbl.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(24)
        }

        // title view.
        let title2Lbl = UILabel()
        title2Lbl.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        title2Lbl.textColor = UIColor.lightGray
        title2Lbl.text = str_point
        view.addSubview(title2Lbl)
        
        title2Lbl.snp.makeConstraints { make in
            make.top.equalTo(amountLbl.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        
        // set collectionview.
        let height: CGFloat = 220
        
        let layout = PointLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.itemSize = CGSize(width: screenWidth - 2 * 24, height: height)
        
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        collectionView.register(PointCell.self, forCellWithReuseIdentifier: PointCell.id)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(title2Lbl.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
//    private func setSubView2() {
//        view.backgroundColor = UIColor.white
//        
//        let bkView = UIView()
//        bkView.backgroundColor = UIColor.white
//        view.addSubview(bkView)
//        
//        let balanceTitleLbl = UILabel()
//        balanceTitleLbl.textColor = UIColor.black
//        balanceTitleLbl.text = str_your_coin
//        balanceTitleLbl.textAlignment = .center
//        balanceTitleLbl.font = UIFont.boldSystemFont(ofSize: 20)
//        view.addSubview(balanceTitleLbl)
//        balanceTitleLbl.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
//            make.left.right.equalToSuperview().inset(24)
//            make.height.equalTo(24)
//        }
//        
//        let balanceLbl = UILabel()
//        balanceLbl.textColor = UIColor.orange
//        balanceLbl.textAlignment = .center
//        balanceLbl.font = UIFont.boldSystemFont(ofSize: 24)
//        view.addSubview(balanceLbl)
//        balanceLbl.snp.makeConstraints { make in
//            make.top.equalTo(balanceTitleLbl.snp.bottom).offset(12)
//            make.left.right.equalToSuperview().inset(24)
//            make.height.equalTo(30)
//        }
//    
//        // コイン数を設定する.
//        viewModel.balance.asObservable().map{"\($0) \(symbol)"}.bind(to: balanceLbl.rx.text).disposed(by: disposeBag)
//        
//        // 屏幕中间的欢迎信息.
//        let welcomeLbl = UILabel()
//        welcomeLbl.textColor = UIColor.black
//        welcomeLbl.font = UIFont.boldSystemFont(ofSize: 20)
//        print("user name = \(userName)")
//        let welcomeMsg = localize(key: "welcome", arguments: userName)
//        print("welcome messge = \(welcomeMsg)")
//        welcomeLbl.text = welcomeMsg
//        welcomeLbl.numberOfLines = 1
//        view.addSubview(welcomeLbl)
//        welcomeLbl.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        
//        // 下方二维码的view
//        let titleLbl = UILabel()
//        titleLbl.textColor = UIColor.white
//        titleLbl.textAlignment = .center
//        titleLbl.backgroundColor = UIColor.orange
//        titleLbl.text = msg1
//        bkView.addSubview(titleLbl)
//        
//        print("生成二维码")
//        let qrCodeView = UIImageView()
//        qrCodeView.image = generateQR(from: "\(userName)\n\(ownerPubKey)\n\(activePubKey)\n\(memoPubKey)\n")
//        bkView.addSubview(qrCodeView)
//        
//        bkView.snp.makeConstraints { make in
//            make.height.equalTo(200)
//            make.left.equalTo(view)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            make.right.equalTo(view)
//        }
//        
//        titleLbl.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.height.equalTo(40)
//        }
//        
//        qrCodeView.snp.makeConstraints { make in
//            make.top.equalTo(titleLbl.snp.bottom).offset(20)
//            make.width.height.equalTo(120)
//            make.centerX.equalToSuperview()
//        }
//    }
}

extension HomeController: UICollectionViewDelegate {
    
}

extension HomeController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.points.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PointCell.id, for: indexPath) as! PointCell
        let data = viewModel.points.value[indexPath.item]
        cell.configure(width: data)
        return cell
    }
}
