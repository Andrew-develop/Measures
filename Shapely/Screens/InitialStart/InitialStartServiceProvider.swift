//
//  InitialStartServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import RxSwift

protocol InitialStartServiceProvider: AnyObject {
    func calculateCalorieIntake(with userData: UserData) -> Observable<Int>

    var rx_activityLevel: Observable<ActivityLevel> { get }
}

final class InitialStartServiceProviderImpl {
    private let activityLevelService: ActivityLevelServiceProvider
    private let calorieCalculator: CalorieCalculator

    init(activityLevelService: ActivityLevelServiceProvider,
         calorieCalculator: CalorieCalculator) {
        self.activityLevelService = activityLevelService
        self.calorieCalculator = calorieCalculator
    }
}

extension InitialStartServiceProviderImpl: InitialStartServiceProvider {
    func calculateCalorieIntake(with userData: UserData) -> Observable<Int> {
        calorieCalculator.calculateCalorieIntake(with: userData)
    }

    var rx_activityLevel: RxSwift.Observable<ActivityLevel> {
        activityLevelService.rx_activityLevel
    }
}
