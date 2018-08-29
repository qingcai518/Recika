//
//  LoginController.swift
//  DigitalReceipt
//
//  Created by liqc on 2018/08/23.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginController: ViewController {
    let viewModel = LoginViewModel()
    
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
        titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        titleLbl.text = str_login
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
        
        let loginBtn = UIButton()
        loginBtn.setTitle(str_login, for: .normal)
        loginBtn.setTitleColor(UIColor.orange, for: .normal)
        loginBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(loginBtn)
        
        let toSignupBtn = UIButton()
        toSignupBtn.setTitle(str_signup, for: .normal)
        toSignupBtn.setTitleColor(UIColor.blue, for: .normal)
        toSignupBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(toSignupBtn)
        
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
        
        loginBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(passwordTF.snp.bottom).offset(24)
            make.height.equalTo(50)
        }
        
        toSignupBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(passwordTF.snp.bottom).offset(24)
            make.width.equalTo(100)
        }
        
        toSignupBtn.rx.tap.asObservable().bind {
            UIApplication.shared.keyWindow?.rootViewController = SignupController()
        }.disposed(by: disposeBag)
        
        loginBtn.rx.tap.bind { [weak self] in
            let name = nameTF.text
            let password = passwordTF.text
            self?.viewModel.doLogin(name: name, password: password, completion: { msg in
                if let msg = msg {
                    self?.showToast(text: msg)
                } else {
                    let next = TopController()
                    UIApplication.shared.keyWindow?.rootViewController = next
                }
            })
        }.disposed(by: disposeBag)
    }
}