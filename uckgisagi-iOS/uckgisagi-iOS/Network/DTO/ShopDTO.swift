//
//  ShopDTO.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/01.
//

struct ShopDTO: Decodable {
    let id: Int
    let name: String
    let location: String
    let imageURL: String
}

extension ShopDTO: Equatable, Hashable {
    static func == (lhs: ShopDTO, rhs: ShopDTO) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ShopListDTO: Decodable{
    let hots: [ShopDTO]
    let shops: [ShopDTO]
}
