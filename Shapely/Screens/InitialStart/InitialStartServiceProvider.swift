//
//  InitialStartServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import RxSwift
import CoreData

protocol InitialStartServiceProvider: AnyObject {
    func calculateCalorieIntake(with userData: UserData) -> Observable<Int>
    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T>

    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]>

    var rx_activityLevel: Observable<ActivityLevel> { get }
}

final class InitialStartServiceProviderImpl {
    private let activityLevelService: ActivityLevelServiceProvider
    private let calorieCalculator: CalorieCalculator
    private let storageService: StorageService

    init(activityLevelService: ActivityLevelServiceProvider,
         calorieCalculator: CalorieCalculator,
         storageService: StorageService) {
        self.activityLevelService = activityLevelService
        self.calorieCalculator = calorieCalculator
        self.storageService = storageService
    }
}

extension InitialStartServiceProviderImpl: InitialStartServiceProvider {
    func calculateCalorieIntake(with userData: UserData) -> Observable<Int> {
        calorieCalculator.calculateCalorieIntake(with: userData)
    }

    func create<T: NSManagedObject>(_ entity: T.Type,
                                    _ body: @escaping (inout T) -> Void) -> Observable<T> {
        storageService.create(entity, body).asObservable()
    }

    func fetch<T: NSManagedObject>(_ entity: T.Type) -> Observable<[T]> {
        storageService.fetch(entity).asObservable()
    }

    var rx_activityLevel: RxSwift.Observable<ActivityLevel> {
        activityLevelService.rx_activityLevel
    }
}
