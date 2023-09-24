//
//  ActivityLevelServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import RxSwift

protocol ActivityLevelServiceProvider: AnyObject {
    func levelSelected(with value: ActivityLevel)

    var rx_activityLevel: Observable<ActivityLevel> { get }
}

final class ActivityLevelServiceProviderImpl {
    private let activityLevelSubject = PublishSubject<ActivityLevel>()
}

extension ActivityLevelServiceProviderImpl: ActivityLevelServiceProvider {
    func levelSelected(with value: ActivityLevel) {
        activityLevelSubject.onNext(value)
    }

    var rx_activityLevel: Observable<ActivityLevel> {
        activityLevelSubject.asObserver()
    }
}
