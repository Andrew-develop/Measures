//
//  LaunchServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 12.02.2023.
//

import RxSwift
import CoreData

protocol LaunchServiceProvider: AnyObject {
    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]>
}

final class LaunchServiceProviderImpl {
    private let storageService: StorageService

    init(storageService: StorageService) {
        self.storageService = storageService
    }
}

extension LaunchServiceProviderImpl: LaunchServiceProvider {
    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]> {
        storageService.fetch(entity).asObservable()
    }
}
