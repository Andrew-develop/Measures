//
//  CalorieCalculator.swift
//  Shapely
//
//  Created by Andrew on 22.02.2023.
//

import RxSwift
import RxCocoa

final class CalorieCalculator {
    func calculateCalorieIntake(with userData: UserData) -> Observable<Int> {
        return Observable<Int>.create { [weak self] observer in
            guard let age = self?.calculateAge(from: userData.birthday) else {
                observer.onCompleted()
                return Disposables.create()
            }

            let gender = userData.gender
            let value = gender.baseCoef + gender.weightCoef *
            userData.weight + gender.heightCoef *
            userData.height - gender.ageCoef * Double(age)

            observer.onNext(Int(value))
            observer.onCompleted()

            return Disposables.create()
        }
    }

    private func calculateAge(from birthday: Date) -> Int? {
        let ageComponents = Calendar.current.dateComponents([.year], from: birthday, to: .now)
        return ageComponents.year
    }
}
