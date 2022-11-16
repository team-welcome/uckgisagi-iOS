//
//  StoreDTO.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/01.
//

struct StoreDTO: Decodable {
    let id: Int
    let storeName: String
    let address: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case address
        case imageURL = "imageUrl"
        case id = "storeId"
        case storeName
    }
}

extension StoreDTO: Equatable, Hashable {
    static func == (lhs: StoreDTO, rhs: StoreDTO) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct StoreListDTO: Decodable {
    let mostPopularStore: [StoreDTO]
    let restStore: [StoreDTO]
}
