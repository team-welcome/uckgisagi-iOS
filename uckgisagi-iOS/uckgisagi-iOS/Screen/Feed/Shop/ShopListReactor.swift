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
        var shopList: StoreListDTO?
        var isLoading: Bool = false
    }

    enum Action {
        case viewWillAppear
        case pullToRefresh
    }

    enum Mutation {
        case setShopList(StoreListDTO)
        case setLoading(Bool)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear, .pullToRefresh:
            return Observable.concat([
                Observable.just(.setLoading(true)),
                NetworkService.shared.store.getStoreList()
                    .compactMap { $0.data }
                    .map { Mutation.setShopList($0) },
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
