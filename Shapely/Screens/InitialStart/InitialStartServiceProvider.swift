//
//  FinishServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import RxSwift
import CoreData

protocol InitialStartServiceProvider: AnyObject {
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T>

    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]>

    func update() -> Observable<Void>

    var rx_activityLevel: Observable<ActivityLevel> { get }
}

final class InitialStartServiceProviderImpl {
    private let storageService: StorageService
    private let activityLevelService: ActivityLevelServiceProvider
    var user = UserData(
        gender: .male,
        birthday: Date(),
        target: .loseWeight,
        height: 170.0,
        weight: 60.0,
        activityLevel: .good,
        treckingParameters: [.chest, .biceps, .waist, .pelvis, .hip],
        calorieIntake: 2200
    )

    init(storageService: StorageService,
         activityLevelService: ActivityLevelServiceProvider) {
        self.storageService = storageService
        self.activityLevelService = activityLevelService
    }
}

extension InitialStartServiceProviderImpl: InitialStartServiceProvider {
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T> {
        storageService.create(entity, body).asObservable()
    }

    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]> {
        storageService.fetch(entity).asObservable()
    }

    func update() -> Observable<Void> {
        storageService.update()
    }

    var rx_activityLevel: Observable<ActivityLevel> {
        activityLevelService.rx_activityLevel
    }
}
