//
//  LoginViewController.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/10/29.
//

import UIKit

import SnapKit
import ReactorKit
import RxSwift

class LoginViewController: BaseViewController, View {
    typealias Reactor = LoginReactor
    
    init(reactor: Reactor) {
        super.init()
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: - properties 
    private let ukgisagiLogo = UIImageView()
    private let ukgisagiLabel = UILabel()
    private let appleLoginButton = UIButton()
    
    // MARK: - layout
    override func setLayouts() {
        ukgisagiLogo.snp.makeConstraints {
            $0.width.equalTo(250)
            $0.height.equalTo(113)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(273)
        }
        
        ukgisagiLabel.snp.makeConstraints {
            $0.top.equalTo(ukgisagiLogo.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(ukgisagiLabel.snp.bottom).offset(128)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(48)
        }
    }
    
    override func setProperties() {
        view.addSubviews(ukgisagiLogo, ukgisagiLabel, appleLoginButton)
        ukgisagiLogo.image = Image.bigLogo
        
        ukgisagiLabel.text = "억지로 지구를 사랑하는 지구인들"
        ukgisagiLabel.textColor = Color.green
        ukgisagiLabel.font = .systemFont(ofSize: 18, weight: .thin)
        
        appleLoginButton.setTitle(" Apple로 시작하기", for: .normal)
        appleLoginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        appleLoginButton.setImage(Image.appleLogo, for: .normal)
        appleLoginButton.setTitleColor(.white, for: .normal)
        appleLoginButton.backgroundColor = .black
        appleLoginButton.layer.cornerRadius = 24
    }
    
    func bind(reactor: LoginReactor) {
        appleLoginButton.rx
            .tap
            .map { .doLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isAppleLoginSuccess)
            .bind { [weak self] status in
                if status {
                    // TODO: - 화면 전환 코드 넣어두기
                }
            }
            .disposed(by: disposeBag)
    }
    
}

