//
//  ShopListReactor.swift
//  uckgisagi-iOS
//
//  Created by 김윤서 on 2022/11/02.
//

import ReactorKit

final class ShopListReactor: Reactor {

    let initialState: State

    init() {
        initialState = State()
    }

    struct State {
        var shopList: ShopListDTO?
        var isLoading: Bool = false
    }

    enum Action {
        case viewWillAppear
        case pullToRefresh
    }

    enum Mutation {
        case setShopList(ShopListDTO)
        case setLoading(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear, .pullToRefresh:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                Observable.just(.setShopList(
                    ShopListDTO(
                        hots: [
                            ShopDTO(id: 1, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 2, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 3, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 4, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 5, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: "")
                        ],
                        shops: [
                            ShopDTO(id: 6, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 7, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 8, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 9, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 10, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 11, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: ""),
                            ShopDTO(id: 12, name: "알맹상점 리필스테이션", location: "서울특별시 중구 한강대로 405, 서울역 4층 야외주차장 옥상정원) 나무건물", imageURL: "")
                        ]
                    )
                )),
                Observable.just(.setLoading(false))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setShopList(shop):
            newState.shopList = shop
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }

}
