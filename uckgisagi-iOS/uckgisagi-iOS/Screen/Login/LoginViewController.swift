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
import SafariServices
import AuthenticationServices

class LoginViewController: BaseViewController {
    // MARK: - properties 
    private let ukgisagiLogo = UIImageView()
    private let ukgisagiLabel = UILabel()
    private let appleLoginButton = ASAuthorizationAppleIDButton()
    private let contentLabel = UILabel()
    private let agreementLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    // MARK: - layout
    override func setLayouts() {
        view.addSubviews(ukgisagiLogo, ukgisagiLabel, appleLoginButton, contentLabel, agreementLabel)
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
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        agreementLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    override func setProperties() {
        ukgisagiLogo.image = Image.bigLogo
        
        ukgisagiLabel.text = "억지로 지구를 사랑하는 지구인들"
        ukgisagiLabel.textColor = Color.green
        ukgisagiLabel.font = .systemFont(ofSize: 18, weight: .regular)
        
        (appleLoginButton as UIControl).cornerRadius = 25
        [contentLabel, agreementLabel].forEach {
            $0.font = .systemFont(ofSize: 12, weight: .thin)
            $0.textAlignment = .center
            $0.textColor = Color.black
        }
        contentLabel.text = "계속 진행하면 억지사지 서비스 약관에 동의하고"
        agreementLabel.text = "개인정보 보호정책과 EULA를 읽었음을 인정하는 것으로 간주됩니다."
        setUnderLineAttributes()
    }
    
    func bind() {
        appleLoginButton.addTarget(self, action: #selector(openAppleLogin), for: .touchUpInside)
        addTapGesture()
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


    private func addTapGesture() {
        let taps = UITapGestureRecognizer(target: self, action: #selector(didTapHyperlink(_:)))
        contentLabel.isUserInteractionEnabled = true
        contentLabel.addGestureRecognizer(taps)

        let taps2 = UITapGestureRecognizer(target: self, action: #selector(didTapHyperlink2(_:)))
        agreementLabel.isUserInteractionEnabled = true
        agreementLabel.addGestureRecognizer(taps2)
    }

    // MARK: - Function
    @objc
    private func didTapHyperlink(_ sender: UITapGestureRecognizer) {
        guard let content = contentLabel.text else { return }

        let termsURL = [
            URLConstant.term,
        ]
        let ranges: [NSRange] = [
            (content as NSString).range(of: "억지사지 서비스 약관")
        ]

        let tapLocation = sender.location(in: contentLabel)
        let index = contentLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        for range in ranges {
            if range.checkTargetWordSelectedRange(contain: index) {
                guard let target = ranges.firstIndex(of: range) else { return }
                let scheme = termsURL[target]
                guard
                    let encodingScheme = scheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: encodingScheme.trimmingSpace()), UIApplication.shared.canOpenURL(url)
                else { return }

                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true)
            }
        }
    }

    @objc
    private func didTapHyperlink2(_ sender: UITapGestureRecognizer) {
        guard let content = agreementLabel.text else { return }

        let termsURL = [
            URLConstant.term,
            URLConstant.eula
        ]

        let ranges: [NSRange] = [
            (content as NSString).range(of: "개인정보 보호정책"),
            (content as NSString).range(of: "EULA")
        ]

        let tapLocation = sender.location(in: agreementLabel)
        let index = agreementLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        for range in ranges {
            if range.checkTargetWordSelectedRange(contain: index) {
                guard let target = ranges.firstIndex(of: range) else { return }
                let scheme = termsURL[target]
                guard
                    let encodingScheme = scheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: encodingScheme.trimmingSpace()), UIApplication.shared.canOpenURL(url)
                else { return }

                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true)
            }
        }
    }

    private func setUnderLineAttributes() {
        guard let title = contentLabel.text else { return }

        let attributeString = NSMutableAttributedString(string: title)
        attributeString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: 1,
            range: (title as NSString).range(of: "억지사지 서비스 약관")
        )
        contentLabel.attributedText = attributeString

        guard let title = agreementLabel.text else { return }

        let attributeString2 = NSMutableAttributedString(string: title)

        attributeString2.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: 1,
            range: (title as NSString).range(of: "개인정보 보호정책")
        )
        attributeString2.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: 1,
            range: (title as NSString).range(of: "EULA")
        )
        agreementLabel.attributedText = attributeString2
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

extension NSRange {
    func checkTargetWordSelectedRange(contain index: Int) -> Bool {
        return index > location && index < location + length
    }
}
