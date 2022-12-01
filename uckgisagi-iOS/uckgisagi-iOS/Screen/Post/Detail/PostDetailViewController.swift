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
        
    }
 
    private func setActionSheet() {
        let defaultAction =  UIAlertAction(title: "신고하기", style: UIAlertAction.Style.default)
        let cancelAction = UIAlertAction(title: "취소하기", style: UIAlertAction.Style.cancel, handler: nil)
        let destructiveAction = UIAlertAction(title: "차단하기", style: UIAlertAction.Style.destructive){(_) in
            
        }
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.addAction(destructiveAction)
        
        self.present(alert, animated: false)
    }
}

extension PostDetailViewController: PostDetailViewDelegate {
    func presentAlertController() {
        self.present(alert, animated: true)
    }
}
