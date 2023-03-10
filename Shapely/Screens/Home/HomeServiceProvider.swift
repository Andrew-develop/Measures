//
//  HomeServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import RxSwift

protocol HomeServiceProvider: AnyObject {
    var rx_getUserData: Observable<[User]?> { get }
    func addUser(_ body: @escaping (inout User) -> Void) -> Observable<Void>
}

final class HomeServiceProviderImpl {
    private let userStorage: StorageService<User>

    init(userStorage: StorageService<User>) {
        self.userStorage = userStorage
    }
}

extension HomeServiceProviderImpl: HomeServiceProvider {
    var rx_getUserData: Observable<[User]?> {
        userStorage.fetch().asObservable()
    }

    func addUser(_ body: @escaping (inout User) -> Void) -> Observable<Void> {
        userStorage.add(body).asObservable()
    }
}
