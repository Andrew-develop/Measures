//
//  InitialStartPack.swift
//  Shapely
//
//  Created by Andrew on 17.02.2023.
//

import Foundation

enum InitialStartSection {
    enum Start: Int, CaseIterable {
        case text
        case picture
    }

    enum PersonalInfo: Int, CaseIterable {
        case segment
        case birthTitle
        case birthData
        case targetTitle
        case targetData
    }

    enum CalorieIntake: Int, CaseIterable {
        case heightTitle
        case heightTape
        case weightTitle
        case weightTape
        case activityTitle
        case activityData
    }

    enum Parameters: Int, CaseIterable {
        case values
    }

    enum Finish: Int, CaseIterable {
        case firstText
        case edit
        case secondText
    }
}
