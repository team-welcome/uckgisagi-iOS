//
//  UserProfileTableViewHeader.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/01.
//

import UIKit

import SnapKit

class UserProfileTableViewHeader: UITableViewHeaderFooterView {
    private lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 48, height: 54)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: .zero)
        return collectionView
    }()
    private lazy var dataSource = UserProfileDataSource(collectionView: self.collectionView)
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayouts()
        dataSource.updateSnapshot()
        setupCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayouts() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension UserProfileTableViewHeader: UICollectionViewDelegate {
    func setupCollectionView() {
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselect")
    }
}
