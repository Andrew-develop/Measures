//
//  Angel.swift
//  Shapely
//
//  Created by Andrew on 25.03.2023.
//

import Foundation

enum Angel: String, CaseIterable, CustomStringConvertible {
    case front
    case side
    case back

    var description: String {
        switch self {
        case .front:
            return "Спереди"
        case .side:
            return "Сбоку"
        case .back:
            return "Сзади"
        }
    }
}
