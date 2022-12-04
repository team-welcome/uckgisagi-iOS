//
//  Date+.swift
//  uckgisagi-iOS
//
//  Created by Sojin Lee on 2022/12/03.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
