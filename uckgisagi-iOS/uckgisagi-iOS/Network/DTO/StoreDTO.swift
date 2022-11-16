//
//  StoreDTO.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/01.
//

struct StoreDTO: Decodable {
    let id: Int
    let name: String
    let location: String
    let imageURL: String
}

extension StoreDTO: Equatable, Hashable {
    static func == (lhs: StoreDTO, rhs: StoreDTO) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ShopListDTO: Decodable{
    let hots: [StoreDTO]
    let shops: [StoreDTO]
}
