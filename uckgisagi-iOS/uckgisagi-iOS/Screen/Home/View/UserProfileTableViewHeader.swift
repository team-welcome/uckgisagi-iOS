//
//  UserProfileTableViewHeader.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/01.
//

import UIKit

import SnapKit
import RxSwift
import ReactorKit

protocol UserProfileTableViewHeaderDelegate: AnyObject {
    func addButtonDidTap(_ header: UserProfileTableViewHeader)
}

class UserProfileTableViewHeader: UITableViewHeaderFooterView {
    var disposeBag = DisposeBag()
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 48, height: 54)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: .zero)
        return collectionView
    }()
//    private lazy var userProfileDataSource = UserProfileDataSource(collectionView: self.collectionView)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayouts()
//        userProfileDataSource.updateSnapshot()
//        setupCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func setLayouts() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//extension UserProfileTableViewHeader: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileCollectionViewCell.identifier, for: indexPath) as? UserProfileCollectionViewCell else { return UICollectionViewCell() }
//
//        cell.configureProfile(name: "뭉", isFriend: false)
//
//        return cell
//    }
//
//    func setupCollectionView() {
//        collectionView.register(UserProfileCollectionViewCell.self, forCellWithReuseIdentifier: UserProfileCollectionViewCell.identifier)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("didselect")
//        if indexPath.row == 4 {
//            delegate?.addButtonDidTap(self)
//        }
//    }
//}
//
///**
// 1) delegate
// 2) rx
// 3) noti
// */
