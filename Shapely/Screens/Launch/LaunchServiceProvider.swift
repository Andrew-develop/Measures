//
//  LaunchServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 12.02.2023.
//

import RxSwift

protocol LaunchServiceProvider: AnyObject {
    var rx_getUserData: Observable<[User]?> { get }
}

final class LaunchServiceProviderImpl {
    private let userStorage: StorageService<User>

    init(userStorage: StorageService<User>) {
        self.userStorage = userStorage
    }
}

extension LaunchServiceProviderImpl: LaunchServiceProvider {
    var rx_getUserData: Observable<[User]?> {
        userStorage.fetch().asObservable()
    }
}
