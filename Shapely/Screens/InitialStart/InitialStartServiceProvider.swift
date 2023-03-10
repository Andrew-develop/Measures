//
//  InitialStartServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import RxSwift

protocol InitialStartServiceProvider: AnyObject {
    func calculateCalorieIntake(with userData: UserData) -> Observable<Int>
    func addUser(_ body: @escaping (inout User) -> Void) -> Observable<Void>

    var rx_activityLevel: Observable<ActivityLevel> { get }
}

final class InitialStartServiceProviderImpl {
    private let activityLevelService: ActivityLevelServiceProvider
    private let calorieCalculator: CalorieCalculator
    private let userStorage: StorageService<User>

    init(activityLevelService: ActivityLevelServiceProvider,
         calorieCalculator: CalorieCalculator,
         userStorage: StorageService<User>) {
        self.activityLevelService = activityLevelService
        self.calorieCalculator = calorieCalculator
        self.userStorage = userStorage
    }
}

extension InitialStartServiceProviderImpl: InitialStartServiceProvider {
    func calculateCalorieIntake(with userData: UserData) -> Observable<Int> {
        calorieCalculator.calculateCalorieIntake(with: userData)
    }

    func addUser(_ body: @escaping (inout User) -> Void) -> Observable<Void> {
        userStorage.add(body).asObservable()
    }

    var rx_activityLevel: RxSwift.Observable<ActivityLevel> {
        activityLevelService.rx_activityLevel
    }
}
