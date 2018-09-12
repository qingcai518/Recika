//
//  AssociateController.swift
//  Recika
//
//  Created by liqc on 2018/08/30.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import RxSwift

class AssociateController: ViewController {
    let viewModel = AssociateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        view.backgroundColor = UIColor.white
        
        let titleLbl = UILabel()
        titleLbl.textColor = UIColor.black
        titleLbl.text = "Cybexのクラウドウォレットアカウントと連携します¥nクラウドウェレットではないアカウントとの連携ができません。ご注意ください。"
        titleLbl.font = UIFont.systemFont(ofSize: 16)
        titleLbl.numberOfLines = 0
        view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
            make.left.right.equalToSuperview().inset(24)
        }
        
        let nameTF = UITextField()
        nameTF.textColor = UIColor.black
        nameTF.placeholder = str_email
        nameTF.borderStyle = .roundedRect
        view.addSubview(nameTF)
        nameTF.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(36)
            make.left.right.equalToSuperview().inset(36)
            make.height.equalTo(50)
        }
        
        let passwordTF = UITextField()
        passwordTF.textColor = UIColor.black
        passwordTF.placeholder = str_password
        passwordTF.borderStyle = .roundedRect
        passwordTF.isSecureTextEntry = true
        view.addSubview(passwordTF)
        passwordTF.snp.makeConstraints { make in
            make.top.equalTo(nameTF.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(36)
            make.height.equalTo(50)
        }
        
        let confirmBtn = UIButton()
        confirmBtn.setTitle("連携する", for: .normal)
        confirmBtn.setTitleColor(UIColor.orange, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        confirmBtn.layer.cornerRadius = 12
        confirmBtn.layer.borderColor = UIColor.lightGray.cgColor
        confirmBtn.layer.borderWidth = 1
        confirmBtn.clipsToBounds = true
        view.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(36)
            make.height.equalTo(50)
        }
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("キャンセル　", for: .normal)
        cancelBtn.setTitleColor(UIColor.gray, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.layer.cornerRadius = 12
        cancelBtn.layer.borderColor = UIColor.lightGray.cgColor
        cancelBtn.layer.borderWidth = 1
        cancelBtn.clipsToBounds = true
        view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(confirmBtn.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(36)
            make.height.equalTo(50)
        }
        
        // 按钮动作.
        confirmBtn.rx.tap.bind { [weak self] in
            self?.viewModel.associate(name: nameTF.text, password: passwordTF.text, completion: { msg in
                if let msg = msg {
                    self?.showToast(text: msg)
                } else {
                    self?.showToast(text: "連携が完了しました。")
                    self?.dismiss(animated: true, completion: nil)
                }
            })
        }.disposed(by: disposeBag)
        
        cancelBtn.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}
