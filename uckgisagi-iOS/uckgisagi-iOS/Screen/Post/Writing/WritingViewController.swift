//
//  WritingViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/08.
//

import UIKit

import Photos
import RxCocoa
import RxSwift
import SnapKit
import ReactorKit

final class WritingViewController: BaseViewController, View {
    private let writingView = WritingView()

    private var image = Image.icDefaultImage {
        didSet {
            writingView.imageView.image = image
            enableDoneButton()
            if image === Image.icDefaultImage {
                writingView.imageView.contentMode = .scaleAspectFit
                return
            }
            writingView.imageView.contentMode = .scaleAspectFill
        }
    }

    override init() {
        super.init()
        hideKeyboardWhenTappedAround()
    }

    override func loadView() {
        view = writingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: WritingReactor) {
        bindTextView()
        bindKeyboardNotification()

        writingView.doneButton.rx.tap
            .map { [weak self] _ -> (image: UIImage, text: String)? in
                guard
                    let self = self,
                    let image = self.writingView.imageView.image,
                    let text = self.writingView.textView.text
                else { return nil }
                return (image, text)
            }
            .compactMap { $0 }
            .map { Reactor.Action.finishWriting(text: $0.text, image: $0.image) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        writingView.cancelButton.rx.tap
            .withUnretained(self)
            .bind { owner,  _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        writingView.imageView.rx.tapGesture
            .withUnretained(self)
            .subscribe { owner, _ in
                if owner.image === Image.icDefaultImage {
                    owner.showPhotoLibrary()
                    return
                }
                owner.image = Image.icDefaultImage
            }
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.isLoading }
            .withUnretained(self)
            .bind { owner, isLoading in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.isUpdated }
            .withUnretained(self)
            .bind { this in
                NetworkService.shared.home.event.onNext(.refreshPost)
            }
            .disposed(by: disposeBag)
    }

    override func keyboardWillShowAnimation(height: CGFloat, bottomPadding: CGFloat) {
        super.keyboardWillShowAnimation(height: height, bottomPadding: bottomPadding)
        writingView.containerStackView.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(-height - 10)
        }
    }

    override func keyboardWillHideAnimation() {
        super.keyboardWillHideAnimation()
        writingView.containerStackView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
    }

    private func bindTextView() {
        writingView.textView.rx.text
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.enableDoneButton()
            }
            .disposed(by: disposeBag)
    }

    private func showPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.allowsEditing = true

        let authorize = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if authorize == .denied {
            return
        }

        imagePicker.sourceType = .photoLibrary
        requestPHPhotoLibraryAuthorization {
            DispatchQueue.main.async {
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }

    private func enableDoneButton() {
        let hasImage = !(image === Image.icDefaultImage)
        let hasText = !writingView.textView.text.isEmpty
        writingView.doneButton.isEnabled = hasImage && hasText
    }

    private func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { authorizationStatus in
            switch authorizationStatus {
            case .limited:
                completion()
            case .authorized:
                completion()
            default:
                break
            }
        }
    }
}

extension WritingViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else { return }

        dismiss(animated: true, completion: nil)
        self.image = image
    }
}

extension WritingViewController: UINavigationControllerDelegate {}
