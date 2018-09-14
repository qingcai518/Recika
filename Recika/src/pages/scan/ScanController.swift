//
//  ScanController.swift
//  Recika
//
//  Created by liqc on 2018/09/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import RxSwift

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
    lazy var alert = UIAlertController(title: nil, message: "解析中...", preferredStyle: .alert)
    
    // receipt.
    var receipt = Receipt()
    var analyzing = Variable(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receipt.delegate = self
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
        let maskWidth = screenWidth / 6
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
        flashBtn.setImage(flashOff, for: .normal)
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
            if self.analyzing.value { return }
            self.analyzing.value = true
            
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.flashMode = .off
            self.flashBtn.setImage(flashOff, for: .normal)
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
    
    func bind() {
        analyzing.asObservable().bind { [weak self] value in
            guard let `self` = self else {return}
            if value {
                self.present(self.alert, animated: true, completion: nil)
            } else {
                self.alert.dismiss(animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
    }
    
    func releaseAVSession() {
        session.stopRunning()
        if let input = videoInput {
            session.removeInput(input)
        }
        session.removeOutput(photoOutput)
        videoInput = nil
    }
    
    func switchFlash() {
        guard let camera = AVCaptureDevice.default(for: .video) else {return}
        try? camera.lockForConfiguration()
        if camera.torchMode == .on {
            camera.torchMode = .off
            flashBtn.setImage(flashOff, for: .normal)
        } else {
            camera.torchMode = .on
            flashBtn.setImage(flashOn, for: .normal)
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
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let picData = photo.fileDataRepresentation() else {return}
        self.receipt.requestAnalyze(picData)
    }
}

extension ScanController: ReceiptDelegate {
    func setImage(_ receiptImage: UIImage!) {
        self.receiptImageView.image = receiptImage
    }
    
    func success(_ receiptInfo: UnsafeMutablePointer<AnalyzerReceiptInfo>!) {
        analyzing.value = false
        let info = receiptInfo.pointee
        
        let next = AnalyzeResultController()
        if let tel = info.tel {
            next.paramTel = tel.takeRetainedValue() as String
        }

        next.paramDate = "\(info.date.year)-\(String(format: "%02d", info.date.month))-\(String(format: "%02d", info.date.day)) \(String(format: "%02d", info.date.hour)):\(String(format: "%02d", info.date.minute)):\(String(format: "%02d", info.date.second))"
        next.paramTotalPrice = "\(info.total)"
        next.paramAdjustPrice = "\(info.priceAdjustment)"
        
        let allItems = [info.items.0, info.items.1, info.items.2, info.items.3, info.items.4, info.items.5, info.items.6, info.items.7, info.items.8, info.items.9, info.items.10, info.items.11, info.items.12, info.items.13, info.items.14, info.items.15, info.items.16, info.items.17, info.items.18, info.items.19, info.items.20, info.items.21, info.items.22, info.items.23, info.items.24, info.items.25, info.items.26, info.items.27, info.items.28, info.items.29, info.items.30, info.items.31, info.items.32, info.items.33, info.items.34, info.items.35, info.items.36, info.items.37, info.items.38, info.items.39, info.items.40, info.items.41, info.items.42, info.items.43, info.items.44, info.items.45, info.items.46, info.items.47, info.items.48, info.items.49, info.items.50, info.items.51, info.items.52, info.items.53, info.items.54, info.items.55, info.items.56, info.items.57, info.items.58, info.items.59, info.items.60, info.items.61, info.items.62, info.items.63, info.items.64, info.items.65, info.items.66, info.items.67, info.items.68, info.items.69, info.items.70, info.items.71, info.items.72, info.items.73, info.items.74, info.items.75, info.items.76, info.items.77, info.items.78, info.items.79, info.items.80, info.items.81, info.items.82, info.items.83, info.items.84, info.items.85, info.items.86, info.items.87, info.items.88, info.items.89, info.items.90, info.items.91, info.items.92, info.items.93, info.items.94, info.items.95, info.items.96, info.items.97, info.items.98, info.items.99, info.items.100, info.items.101, info.items.102, info.items.103, info.items.104, info.items.105, info.items.106, info.items.107, info.items.108, info.items.109, info.items.110, info.items.111, info.items.112, info.items.113, info.items.114, info.items.115, info.items.116, info.items.117, info.items.118, info.items.119, info.items.120, info.items.121, info.items.122, info.items.123, info.items.124, info.items.125, info.items.126, info.items.127, info.items.128, info.items.129, info.items.130, info.items.131, info.items.132, info.items.133, info.items.134, info.items.135, info.items.136, info.items.137, info.items.138, info.items.139, info.items.140, info.items.141, info.items.142, info.items.143, info.items.144, info.items.145, info.items.146, info.items.147, info.items.148, info.items.149, info.items.150, info.items.151, info.items.152, info.items.153, info.items.154, info.items.155, info.items.156, info.items.157, info.items.158, info.items.159, info.items.160, info.items.161, info.items.162, info.items.163, info.items.164, info.items.165, info.items.166, info.items.167, info.items.168, info.items.169, info.items.170, info.items.171, info.items.172, info.items.173, info.items.174, info.items.175, info.items.176, info.items.177, info.items.178, info.items.179, info.items.180, info.items.181, info.items.182, info.items.183, info.items.184, info.items.185, info.items.186, info.items.187, info.items.188, info.items.189, info.items.190, info.items.191, info.items.192, info.items.193, info.items.194, info.items.195, info.items.196, info.items.197, info.items.198, info.items.199]
        
        var items = [AnalyzerItemInfo]()
        for item in allItems {
            guard let _ = item.name else {
                continue
            }
            items.append(item)
        }
        
        next.items = items
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func fail(_ msg: String!) {
        self.showToast(text: msg)
        analyzing.value = false
    }
}
