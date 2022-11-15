//
//  CalendarTableViewCell.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/11/01.
//

import UIKit

import SnapKit
import FSCalendar

class CalendarTableViewCell: UITableViewCell {
    static let identifier = "CalendarTableViewCell"
    let monthLabel = UILabel()
    let calendar = FSCalendar(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
        setLayouts()
        setupCalendar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayouts() {
        monthLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(30)
        }
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(self.contentView).inset(25)
            $0.height.equalTo(250)
        }
    }
    
    func setProperties() {
        contentView.addSubviews(monthLabel, calendar)
        
        monthLabel.text = dateformat()
        monthLabel.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 500))
        monthLabel.textColor = Color.mediumGray
    }
}

extension CalendarTableViewCell {
    func dateformat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        let dateString = formatter.string(from: Date())
        return dateString
    }
}

extension CalendarTableViewCell: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
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
