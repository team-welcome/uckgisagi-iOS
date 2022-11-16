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
import AuthenticationServices

class LoginViewController: BaseViewController {
    // MARK: - properties 
    private let ukgisagiLogo = UIImageView()
    private let ukgisagiLabel = UILabel()
    private let appleLoginButton = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
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
        
        (appleLoginButton as UIControl).cornerRadius = 25
    }
    
    func bind() {
        appleLoginButton.addTarget(self, action: #selector(openAppleLogin), for: .touchUpInside)
    }
    
    func doLogin(_ socialToken: String) {
        NetworkService.shared.auth.signup(fcmToken: KeychainHandler.shared.fcmToken, socialToken: socialToken)
            .subscribe(onNext: { response in
                guard let data = response.data else { return }
                KeychainHandler.shared.accessToken = data.accessToken
                KeychainHandler.shared.refreshToken = data.refreshToken
                RootSwitcher.update(.home)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
   
    @objc private func openAppleLogin(_ sender: ASAuthorizationAppleIDButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if let authorizationCode = appleIDCredential.authorizationCode, let identityToken = appleIDCredential.identityToken, let authString = String(data: authorizationCode, encoding: .utf8), let tokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authString: \(authString)")
                print("tokenString: \(tokenString)")
                doLogin(tokenString)
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(String(describing: fullName))")
            print("email: \(String(describing: email))")
            
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패")
    }
}
