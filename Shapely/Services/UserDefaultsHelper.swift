//
//  UserProfileService.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import Foundation

struct UserDefaultsKey {
    static let gender = "gender"
    static let birthday = "birthday"
    static let target = "target"
    static let height = "height"
    static let weight = "weight"
    static let activityLevel = "activityLevel"
    static let treckingParameters = "treckingParameters"
    static let calorieIntake = "calorieIntake"
}

struct UserDefaultsHelper {
    static var gender: Gender {
        if let rawValue = UserDefaults.standard.object(forKey: UserDefaultsKey.gender) as? Int {
            return Gender(rawValue: rawValue) ?? .male
        }
        return .male
    }

    static func setGender(_ gender: Gender) {
        UserDefaults.standard.set(gender.rawValue, forKey: UserDefaultsKey.gender)
    }

    static var birthday: Date {
        get {
            UserDefaults.standard.object(forKey: UserDefaultsKey.birthday) as? Date ?? Date()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.birthday)
        }
    }

    static var target: UserTarget {
        if let rawValue = UserDefaults.standard.object(forKey: UserDefaultsKey.target) as? Int {
            return UserTarget(rawValue: rawValue) ?? .loseWeight
        }
        return .loseWeight
    }

    static func setTarget(_ target: UserTarget) {
        UserDefaults.standard.set(target.rawValue, forKey: UserDefaultsKey.target)
    }

    static var height: Double {
        get {
            UserDefaults.standard.object(forKey: UserDefaultsKey.height) as? Double ?? 170.0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.height)
        }
    }

    static var weight: Double {
        get {
            UserDefaults.standard.object(forKey: UserDefaultsKey.weight) as? Double ?? 60.0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.weight)
        }
    }

    static var activityLevel: ActivityLevel {
        if let rawValue = UserDefaults.standard.object(forKey: UserDefaultsKey.activityLevel) as? Int {
            return ActivityLevel(rawValue: rawValue) ?? .sad
        }
        return .sad
    }

    static func setActivityLevel(_ activityLevel: ActivityLevel) {
        UserDefaults.standard.set(activityLevel.rawValue, forKey: UserDefaultsKey.activityLevel)
    }

    static var treckingParameters: Set<TreckingParameter> {
        if let treckingSet = UserDefaults.standard.object(forKey: UserDefaultsKey.treckingParameters) as? [Int] {
            return Set(treckingSet.map { TreckingParameter(rawValue: $0) ?? .biceps })
        }
        return [.chest, .biceps, .waist, .pelvis, .hip]
    }

    static func setTreckingParameters(_ treckingParameters: Set<TreckingParameter>) {
        UserDefaults.standard.set(treckingParameters.map { $0.rawValue }, forKey: UserDefaultsKey.treckingParameters)
    }

    static var calorieIntake: Int {
        get {
            UserDefaults.standard.object(forKey: UserDefaultsKey.calorieIntake) as? Int ?? 2200
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.calorieIntake)
        }
    }
}
