//
//  PostDetailViewController.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/08.
//

import UIKit

import ReactorKit

final class PostDetailViewController: BaseViewController, View {
    
    private let detailView = PostDetailView()
    private let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    override init() {
        super.init()
        setActionSheet()
    }
    private var postID: Int?

    override func loadView() {
        view = detailView
        detailView.delegate = self
    }
    
    func bind(reactor: PostDetailReactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.post }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, post in
                owner.detailView.configure(
                    imageURL:  post.imageURL,
                    username: post.nickname ?? "",
                    timestamp: post.updatedAt ?? "",
                    content:  post.content
                )
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.isAccusing || $0.isBlocking }
            .filter { $0 }
            .withUnretained(self)
            .bind { _ in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        detailView.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
 
    private func setActionSheet() {
        let accuseAction =  UIAlertAction(title: "신고하기", style: UIAlertAction.Style.default) { _ in
            self.reactor?.action.onNext(.accusePost)
        }
        let cancelAction = UIAlertAction(title: "취소하기", style: UIAlertAction.Style.cancel) { _ in
            print("취소하기")
        }
        let blockAction = UIAlertAction(title: "차단하기", style: UIAlertAction.Style.destructive){(_) in
            print("차단하기")
            self.reactor?.action.onNext(.blockUserPost)
        }

        alert.addAction(accuseAction)
        alert.addAction(cancelAction)
        alert.addAction(blockAction)
        
        self.present(alert, animated: false)
    }
}

extension PostDetailViewController: PostDetailViewDelegate {
    func presentAlertController() {
        self.present(alert, animated: true)
    }
}
