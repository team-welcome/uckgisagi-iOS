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
        layout.itemSize = CGSize(width: 52, height: 52)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: .zero)
        return collectionView
    }()
    
    private let nameLabel = UILabel().then {
        $0.textColor = Color.black
        $0.font = .systemFont(ofSize: 22, weight: .light)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(name: String) {
        print("configure 함수")
        print(name)
        nameLabel.text = name
    }
    
    private func setLayouts() {
        addSubviews(collectionView, nameLabel)
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
}
