//
//  SignupController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/23.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignupController: ViewController {
    let viewModel = SignupViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubViews() {
        let titleLbl = UILabel()
        view.backgroundColor = UIColor.white
        titleLbl.textColor = UIColor.black
        titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        titleLbl.text = str_signup
        view.addSubview(titleLbl)
        
        let nameTF = UITextField()
        nameTF.textColor = UIColor.black
        nameTF.placeholder = str_email
        nameTF.borderStyle = .roundedRect
        view.addSubview(nameTF)
        
        let passwordTF = UITextField()
        passwordTF.textColor = UIColor.black
        passwordTF.placeholder = str_password
        passwordTF.borderStyle = .roundedRect
        passwordTF.isSecureTextEntry = true
        view.addSubview(passwordTF)

        let toLoginBtn = UIButton()
        toLoginBtn.setTitle(str_login, for: .normal)
        toLoginBtn.setTitleColor(UIColor.blue, for: .normal)
        toLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(toLoginBtn)
        
        let signupBtn = UIButton()
        signupBtn.setTitle(str_signup, for: .normal)
        signupBtn.setTitleColor(UIColor.orange, for: .normal)
        signupBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        signupBtn.layer.borderColor = UIColor.lightGray.cgColor
        signupBtn.layer.borderWidth = 1
        signupBtn.layer.cornerRadius = 12
        signupBtn.clipsToBounds = true
        signupBtn.setTitleColor(UIColor.gray, for: .highlighted)
        view.addSubview(signupBtn)
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
        }
        
        nameTF.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(titleLbl.snp.bottom).offset(24)
            make.height.equalTo(50)
        }
        
        passwordTF.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(nameTF.snp.bottom).offset(12)
            make.height.equalTo(50)
        }
        
        signupBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(toLoginBtn.snp.bottom).offset(12)
            make.height.equalTo(50)
        }
        
        toLoginBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(passwordTF.snp.bottom).offset(24)
            make.width.equalTo(100)
        }
        
        toLoginBtn.rx.tap.bind {
            UIApplication.shared.keyWindow?.rootViewController = LoginController()
        }.disposed(by: disposeBag)
        
        signupBtn.rx.tap.bind { [weak self] in
            let name = nameTF.text
            let password = passwordTF.text
            self?.viewModel.doSignup(name: name, password: password, completion: { msg in
                if let msg = msg {
                    self?.showToast(text: msg)
                } else {
                    UIApplication.shared.keyWindow?.rootViewController = TopController()
                }
            })
        }.disposed(by: disposeBag)
    }
}
