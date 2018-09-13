//
//  ScanController.swift
//  Recika
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import AVKit

import UIKit
import AVFoundation

class ScanController: ViewController {
    var stillImageOutput: String?
    var session = AVCaptureSession()
    let camera = AVCaptureDevice.default(for: .video)
    var videoInput: AVCaptureDeviceInput?
    lazy var photoOutput = AVCapturePhotoOutput()
    
    // ui.
    lazy var flashBtn = UIButton()
    lazy var closeBtn = UIButton()
    lazy var cameraView = UIView()
    lazy var topView = UIView()
    lazy var bottomView = UIView()
    lazy var cameraBtn = UIButton()
    lazy var guideBtn = UIButton()
    lazy var typeBtn = UIButton()
    lazy var receiptImageView = UIImageView()
    lazy var leftLine = UIView()
    lazy var rightLine = UIView()
    
    // receipt.
    var receipt = Receipt()
    var analyzing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receipt.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        releaseAVSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.clear
        
        let bottomHeight: CGFloat = 80
        // bottom view.
        bottomView.backgroundColor = UIColor.clear
        view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.clear
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(bottomHeight)
        }

        bottomView.addSubview(cameraBtn)
        bottomView.addSubview(guideBtn)
        bottomView.addSubview(typeBtn)
        
        cameraBtn.setImage(shutter, for: .normal)
        cameraBtn.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        guideBtn.setImage(guide, for: .normal)
        guideBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44)
        }
        
        typeBtn.setImage(receiptType, for: .normal)
        typeBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(44)
        }
        
        /// camera view.
        cameraView.backgroundColor = UIColor.clear
        cameraView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - bottomHeight)
        view.addSubview(cameraView)
        
        // topView.
        topView.backgroundColor = UIColor.clear
        cameraView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        /// receipt image view
        receiptImageView.contentMode = .scaleAspectFit
        cameraView.addSubview(receiptImageView)
        receiptImageView.alpha = 0
        
        receiptImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        // 各种数据.
        ///  mask left line.
        let maskWidth = screenWidth / 5
        leftLine.backgroundColor = UIColor.red
        cameraView.addSubview(leftLine)
        leftLine.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(maskWidth)
            make.width.equalTo(1)
        }
        
        /// mask right line.
        rightLine.backgroundColor = UIColor.red
        cameraView.addSubview(rightLine)
        rightLine.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(maskWidth)
            make.width.equalTo(1)
        }
        
        /// flash button.
        flashBtn.setImage(flashOn, for: .normal)
        topView.addSubview(flashBtn)
        flashBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(12)
            make.height.width.equalTo(44)
        }
        
        /// close button.
        closeBtn.setImage(close, for: .normal)
        topView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(12)
            make.height.width.equalTo(44)
        }
        
        /// button actions.
        flashBtn.rx.tap.bind { [weak self] in
            self?.switchFlash()
        }.disposed(by: disposeBag)
        
        closeBtn.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        /// shutter button.
        cameraBtn.rx.tap.bind { [weak self] in
            guard let `self` = self else {return}
            if self.analyzing { return }
            self.analyzing = true
            
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.flashMode = .off
            photoSettings.isHighResolutionPhotoEnabled = false
            if self.photoOutput.isStillImageStabilizationSupported {
                photoSettings.isAutoStillImageStabilizationEnabled = true
            }
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }.disposed(by: disposeBag)
    }
    
    private func setupCamera() {
        session.sessionPreset = .photo
        guard let camera = camera else {return}
        videoInput = try? AVCaptureDeviceInput(device: camera)
        if let input = videoInput {
            session.addInput(input)
        }
        session.addOutput(photoOutput)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = cameraView.frame
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        cameraView.bringSubview(toFront: leftLine)
        cameraView.bringSubview(toFront: rightLine)
        cameraView.bringSubview(toFront: topView)
        
        DispatchQueue.global().async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func releaseAVSession() {
        session.stopRunning()
        if let input = videoInput {
            session.removeInput(input)
        }
        session.removeOutput(photoOutput)
        videoInput = nil
    }
    
    func checkFlash() {
        guard let camera = AVCaptureDevice.default(for: .video) else {return}
        flashBtn.setImage(camera.torchMode == .on ? flashOn : flashOff, for: .normal)
    }
    
    func switchFlash() {
        guard let camera = AVCaptureDevice.default(for: .video) else {return}
        try? camera.lockForConfiguration()
        if camera.torchMode == .on {
            camera.torchMode = .off
            flashBtn.setImage(flashOn, for: .normal)
        } else {
            camera.torchMode = .on
            flashBtn.setImage(flashOff, for: .normal)
        }
        camera.unlockForConfiguration()
    }
}

extension ScanController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard let sampleBuffer = photoSampleBuffer else {return}
        guard let picData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {return}
        self.receipt.requestAnalyze(picData)
    }
}

extension ScanController: ReceiptDelegate {
    func setImage(_ receiptImage: UIImage!) {
        self.receiptImageView.image = receiptImage
    }
    
    func success(_ receiptInfo: UnsafeMutablePointer<AnalyzerReceiptInfo>!) {
        let info = receiptInfo.pointee
        // to next page.
        print(info)
        analyzing = false
    }
    
    func fail(_ msg: String!) {
        self.showToast(text: msg)
        analyzing = false
    }
}
