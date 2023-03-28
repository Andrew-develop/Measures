//
//  MeasurementServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift
import CoreData

protocol MeasurementServiceProvider: AnyObject {
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T>

    func fetch<T: NSManagedObject>(_ entity: T.Type,
                                   predicate: NSPredicate?) -> Observable<[T]>
    func updateNote() -> Observable<Void>
}

final class MeasurementServiceProviderImpl {
    private let storageService: StorageService

    init(storageService: StorageService) {
        self.storageService = storageService
    }
}

extension MeasurementServiceProviderImpl: MeasurementServiceProvider {
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T> {
        storageService.create(entity, body).asObservable()
    }

    func fetch<T: NSManagedObject>(_ entity: T.Type,
                                   predicate: NSPredicate?) -> Observable<[T]> {
        storageService.fetch(entity, predicate: predicate).asObservable()
    }

    func updateNote() -> Observable<Void> {
        storageService.update().asObservable()
    }
}
