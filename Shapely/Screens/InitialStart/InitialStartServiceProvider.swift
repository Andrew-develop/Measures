//
//  InitialStartServiceProvider.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import RxSwift

protocol InitialStartServiceProvider: AnyObject {
    func calculateCalorieIntake(with userData: UserData) -> Observable<Int>

    func addUser(_ body: @escaping (inout User) -> Void) -> Observable<User>
    func addParameterType(_ body: @escaping (inout ParameterType) -> Void) -> Observable<ParameterType>
    func addParameter(_ body: @escaping (inout Parameter) -> Void) -> Observable<Parameter>

    var rx_parameterTypes: Observable<[ParameterType]?> { get }
    var rx_activityLevel: Observable<ActivityLevel> { get }
}

final class InitialStartServiceProviderImpl {
    private let activityLevelService: ActivityLevelServiceProvider
    private let calorieCalculator: CalorieCalculator
    private let userStorage: StorageService<User>
    private let parameterTypeStorage: StorageService<ParameterType>
    private let parameterStorage: StorageService<Parameter>

    init(activityLevelService: ActivityLevelServiceProvider,
         calorieCalculator: CalorieCalculator,
         userStorage: StorageService<User>,
         parameterTypeStorage: StorageService<ParameterType>,
         parameterStorage: StorageService<Parameter>) {
        self.activityLevelService = activityLevelService
        self.calorieCalculator = calorieCalculator
        self.userStorage = userStorage
        self.parameterTypeStorage = parameterTypeStorage
        self.parameterStorage = parameterStorage
    }
}

extension InitialStartServiceProviderImpl: InitialStartServiceProvider {
    func calculateCalorieIntake(with userData: UserData) -> Observable<Int> {
        calorieCalculator.calculateCalorieIntake(with: userData)
    }

    func addUser(_ body: @escaping (inout User) -> Void) -> Observable<User> {
        userStorage.add(body).asObservable()
    }

    func addParameterType(_ body: @escaping (inout ParameterType) -> Void) -> Observable<ParameterType> {
        parameterTypeStorage.add(body).asObservable()
    }

    func addParameter(_ body: @escaping (inout Parameter) -> Void) -> Observable<Parameter> {
        parameterStorage.add(body).asObservable()
    }

    var rx_parameterTypes: Observable<[ParameterType]?> {
        parameterTypeStorage.fetch().asObservable()
    }

    var rx_activityLevel: RxSwift.Observable<ActivityLevel> {
        activityLevelService.rx_activityLevel
    }
}
