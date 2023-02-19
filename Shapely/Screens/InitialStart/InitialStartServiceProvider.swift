//
//  InitialStartServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import RxSwift

protocol InitialStartServiceProvider: AnyObject {
    var rx_activityLevel: Observable<ActivityLevel> { get }
}

final class InitialStartServiceProviderImpl {
    private let activityLevelService: ActivityLevelServiceProvider

    init(activityLevelService: ActivityLevelServiceProvider) {
        self.activityLevelService = activityLevelService
    }
}

extension InitialStartServiceProviderImpl: InitialStartServiceProvider {
    var rx_activityLevel: RxSwift.Observable<ActivityLevel> {
        activityLevelService.rx_activityLevel
    }
}
