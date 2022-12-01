//
//  String+.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/12/01.
//

import Foundation

extension String {
    func trimmingSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
}
