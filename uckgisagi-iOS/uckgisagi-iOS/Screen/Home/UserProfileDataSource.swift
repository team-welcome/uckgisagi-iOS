//
//  UserPostDataSource.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/04.
//

import UIKit

struct UserProfile: Hashable {
    let id: Int
    let name: String
    let isFriend: Bool
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
      lhs.id == rhs.id
    }
    
    init(id: Int, name: String, isFriend: Bool) {
        self.id = id
        self.name = name
        self.isFriend = isFriend
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.isFriend = false
    }
}

class UserProfileDataSource {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, UserProfile>
    
    private let collectionView: UICollectionView
    private lazy var dataSource = createDataSource()
    var userProfiles: [UserProfile] = [
        UserProfile(id: 1, name: "토", isFriend: false),
        UserProfile(id: 2, name: "뮨", isFriend: true),
        UserProfile(id: 3, name: "짠", isFriend: true),
        UserProfile(id: 4, name: "희", isFriend: true),
    ]
    
    enum Section: CaseIterable {
      case main
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, UserProfile> {
        let cellRegistration = UICollectionView.CellRegistration
        <UserProfileCollectionViewCell, UserProfile> { (cell, indexPath, item) in
            if indexPath.row == 4 {
                cell.configureLastCell()
            } else {
                cell.configureProfile(name: item.name, isFriend: item.isFriend)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, UserProfile>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: UserProfile) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        return dataSource
    }
    
    func updateSnapshot() {
        userProfiles.append(UserProfile())
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UserProfile>()
        snapshot.appendSections([.main])
        snapshot.appendItems(userProfiles)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
