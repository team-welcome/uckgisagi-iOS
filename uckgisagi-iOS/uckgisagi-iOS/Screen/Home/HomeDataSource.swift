//
//  UserPostDataSource.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/08.
//

import UIKit

struct UserPostDTO: Decodable {
    let id: Int
    let time: String
    let text: String
    let imageURL: String
}

extension UserPostDTO: Equatable, Hashable {
    static func == (lhs: UserPostDTO, rhs: UserPostDTO) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CalendarDTO: Decodable {
    let id: Int
    let date: String
}

extension CalendarDTO: Equatable, Hashable {
    static func == (lhs: CalendarDTO, rhs: CalendarDTO) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class HomeDataSource {
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>

    private lazy var dataSource = createDataSource()
    private let tableView: UITableView
    private let postType: PostCase

    enum Section: CaseIterable {
        case calendar
        case post

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .calendar
            case 1: self = .post
            default:
                fatalError("not exist section")
            }
        }
    }

    enum Item: Hashable {
        case calendars(Int)
        case posts(Int)
    }

    init(tableView: UITableView, postType: PostCase) {
        self.tableView = tableView
        self.postType = .postExist
    }

    func createDataSource() -> UITableViewDiffableDataSource<Section, Item> {
        tableView.register(CalendarTableViewCell.self, forCellReuseIdentifier: CalendarTableViewCell.identifier)
        tableView.register(UserPostTableViewCell.self, forCellReuseIdentifier: UserPostTableViewCell.identifier)
        tableView.register(EmptyPostTableViewCell.self, forCellReuseIdentifier: EmptyPostTableViewCell.identifier)


        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) {
            tableView, indexPath, item in
            switch item {
            case .calendars:
                let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath)
                cell.selectionStyle = .none
                return cell
            case .posts:
                switch self.postType {
                case .postExist:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: UserPostTableViewCell.identifier, for: indexPath) as? UserPostTableViewCell else { return UITableViewCell() }
                    cell.selectionStyle = .none
                    cell.configure()
                    return cell
                case .friendPostEmpty:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyPostTableViewCell.identifier, for: indexPath) as? EmptyPostTableViewCell else { return UITableViewCell() }
                    cell.configure(isFriend: true)
                    return cell
                case .ownerPostEmpty:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyPostTableViewCell.identifier, for: indexPath) as? EmptyPostTableViewCell else { return UITableViewCell() }
                    cell.configure(isFriend: false)
                    return cell
                }
            }
        }

        return dataSource
    }
    
    func updateSnapshot() {
        var calendarItem: [CalendarDTO] = [
            CalendarDTO(id: 1, date: "zz")
        ]
        
        var postItem: [UserPostDTO] = [
            UserPostDTO(id: 3, time: "AM 10:13", text: "tq", imageURL: ""),
            UserPostDTO(id: 4, time: "AM 10:13", text: "tq", imageURL: ""),
        ]
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.calendar, .post])
        
        let calendarIds = calendarItem.map { Item.calendars($0.id) }
        let postIds = postItem.map { Item.posts($0.id) }
        
        snapshot.appendItems(calendarIds, toSection: .calendar)
        snapshot.appendItems(postIds, toSection: .post)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

