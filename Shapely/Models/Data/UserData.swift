//
//  UserData.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import Foundation

struct UserData {
    var gender: Gender
    var birthday: Date
    var target: UserTarget
    var height: Double
    var weight: Double
    var activityLevel: ActivityLevel
    var treckingParameters: Set<TreckingParameter>
    var calorieIntake: Int
}
