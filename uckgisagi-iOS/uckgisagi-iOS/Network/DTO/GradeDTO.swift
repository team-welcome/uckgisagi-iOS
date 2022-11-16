//
//  GradeDTO.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/17.
//

/*
 SQUIRE("종자", 2),
 BARON("남작", 5),
 EARL("백작", 10),
 DUKE("공작", 19),
 LORD("영주", 32),
 KING("왕", 53)
  */

enum Grade: String, Decodable {
    case squire = "SQUIRE"
    case baron = "BARON"
    case earl = "EARL"
    case duke = "DUKE"
    case lord = "LORD"
    case king = "KING"
}

struct GradeDTO: Decodable {
    let grade: Grade
}
