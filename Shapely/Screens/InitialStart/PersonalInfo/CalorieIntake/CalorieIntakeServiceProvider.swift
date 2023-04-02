//
//  CalorieIntakeServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import RxSwift

protocol CalorieIntakeServiceProvider: AnyObject {
    var rx_activityLevel: Observable<ActivityLevel> { get }
}

final class CalorieIntakeServiceProviderImpl {
    private let activityLevelService: ActivityLevelServiceProvider

    init(activityLevelService: ActivityLevelServiceProvider) {
        self.activityLevelService = activityLevelService
    }
}

extension CalorieIntakeServiceProviderImpl: CalorieIntakeServiceProvider {
    var rx_activityLevel: RxSwift.Observable<ActivityLevel> {
        activityLevelService.rx_activityLevel
    }
}
