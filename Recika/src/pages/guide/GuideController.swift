//
//  GuideController.swift
//  Recika
//
//  Created by liqc on 2018/09/18.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class GuideController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSubView() {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "")!
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.width.equalTo(240)
        }
        
        let recognizer = UITapGestureRecognizer()
        recognizer.rx.event.bind { [weak self] send in
            self?.dismiss(animated: true, completion: nil)
        }
        self.view.addSubview(recognizer)
        recognizer.delegate = self
    }
}

extension GuideContrtoller: UIGestureRecognizerDelegate {
    func shouldTap() {
        print("showld tap recognizer in view UIVIew.
        z")
    }
}
