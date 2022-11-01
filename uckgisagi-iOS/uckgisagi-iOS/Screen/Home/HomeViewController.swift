//
//  HomeViewController.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/10/29.
//

import UIKit

import SnapKit
import RxSwift
import FSCalendar

class HomeViewController: BaseViewController {
    // MARK: - Properties
    private let navigationView = UIView()
    private let ukgisagiLogo = UIImageView()
    private let surroundButton = UIButton()
    private let homeScrollView = UIScrollView()
    private var userProfileCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: .zero)
        return collectionView
    }()
    private let monthLabel = UILabel()
    private let calendar = FSCalendar(frame: .zero)
    private let testView1 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCalendar()
    }
    
    override func setLayouts() {
        navigationView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(55)
        }
        
        ukgisagiLogo.snp.makeConstraints {
            $0.width.equalTo(104)
            $0.height.equalTo(47)
            $0.leading.equalToSuperview().inset(21)
            $0.centerY.equalToSuperview()
        }
        
        surroundButton.snp.makeConstraints {
            $0.width.height.equalTo(28)
            $0.trailing.equalToSuperview().inset(11)
            $0.centerY.equalToSuperview()
        }
        
        homeScrollView.snp.makeConstraints {
            $0.top.equalTo(userProfileCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        userProfileCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        monthLabel.snp.makeConstraints {
            $0.top.equalTo(homeScrollView.snp.top).offset(10)
            $0.leading.equalTo(30)
        }
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.view).inset(25)
            $0.height.equalTo(250)
        }
        
        testView1.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(10)
            $0.width.equalTo(360)
            $0.height.equalTo(1200)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(30)
        }
    }
    
    override func setProperties() {
        navigationView.addSubviews(ukgisagiLogo, surroundButton)
        view.addSubviews(navigationView, userProfileCollectionView, homeScrollView)
        homeScrollView.addSubviews(monthLabel, calendar, testView1)
        
        ukgisagiLogo.image = Image.bigLogo
        surroundButton.setImage(Image.icSurround, for: .normal)
        testView1.backgroundColor = .blue
        monthLabel.text = dateformat()
        monthLabel.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 500))
        monthLabel.textColor = Color.mediumGray
    }
}

// MARK: - collectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        userProfileCollectionView.delegate = self
        userProfileCollectionView.dataSource = self
        userProfileCollectionView.register(UserProfileCollectionViewCell.self, forCellWithReuseIdentifier: UserProfileCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // MARK: - 서버에서 받는 값으로 수정하기
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileCollectionViewCell.identifier, for: indexPath) as? UserProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.row == 4 {
            cell.configureLastCell()
        } else {
            cell.configureProfile(name: "뭉", isFriend: false) // MARK: - 서버에서 받는 값으로 수정하기
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 54)
    }
}

// MARK: - FSCalendar
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func setupCalendar() {
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.locale = Locale(identifier: "en_EN")
        self.calendar.backgroundColor = .white
        self.calendar.scrollEnabled = false
        
        self.calendar.headerHeight = 0
        self.calendar.appearance.weekdayTextColor = Color.black
        self.calendar.appearance.titleFont = .systemFont(ofSize: 12, weight: .light)
        self.calendar.appearance.headerTitleFont = .systemFont(ofSize: 12, weight: .regular)
        self.calendar.appearance.todayColor = Color.green
        self.calendar.appearance.selectionColor = .clear
        self.calendar.appearance.titleSelectionColor = .black
        
        self.calendar.appearance.eventDefaultColor = Color.green
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // MARK: - 터치시 이벤트
        print(Calendar.current.date(byAdding: .hour, value: 9, to: date))
    }
    
    func setupCalendarEvents(dates: [String]) -> [Date?] {
        let dateFormatter = DateFormatter()
        var eventDate: [Date?] = .init()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dates.forEach { date in
            eventDate.append(dateFormatter.date(from: date) ?? nil)
        }
        return eventDate
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let events = setupCalendarEvents(dates: ["2022-11-26","2022-11-10"])
        if events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
}

// MARK: - custom method
extension HomeViewController {
    func dateformat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        let dateString = formatter.string(from: Date())
        return dateString
    }
}
