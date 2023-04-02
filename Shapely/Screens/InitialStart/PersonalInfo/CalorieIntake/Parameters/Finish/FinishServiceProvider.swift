//
//  FinishServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import RxSwift
import CoreData

protocol FinishServiceProvider: AnyObject {
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T>

    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]>
}

final class FinishServiceProviderImpl {
    private let storageService: StorageService

    init(storageService: StorageService) {
        self.storageService = storageService
    }
}

extension FinishServiceProviderImpl: FinishServiceProvider {
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T> {
        storageService.create(entity, body).asObservable()
    }

    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]> {
        storageService.fetch(entity).asObservable()
    }
}
