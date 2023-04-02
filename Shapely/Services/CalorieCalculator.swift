//
//  CalorieCalculator.swift
//  Shapely
//
//  Created by Andrew on 22.02.2023.
//

import Foundation

struct CalorieCalculator {
    static func calculateCalorieIntake() -> Int {
        guard let age = calculateAge() else { return 2200 }

        let gender = UserDefaultsHelper.gender
        let value = gender.baseCoef + gender.weightCoef *
        UserDefaultsHelper.weight + gender.heightCoef *
        UserDefaultsHelper.height - gender.ageCoef * Double(age)

        return Int(value)
    }

    static func calculateAge() -> Int? {
        let ageComponents = Calendar.current.dateComponents([.year], from: UserDefaultsHelper.birthday, to: .now)
        return ageComponents.year
    }
}
