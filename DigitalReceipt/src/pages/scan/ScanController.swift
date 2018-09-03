//
//  ScanController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import AVKit

class ScanController: ViewController {
    let cameraBtn = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        let camera = AVCaptureDevice.default(for: .video)
    }
}
