//
//  UICalendarViewStyle.swift
//  Shapely
//
//  Created by Andrew on 18.02.2023.
//

import Foundation

import UIKit
extension StyleWrapper where Element == UICalendarView {
    static var primary: StyleWrapper {
        return .wrap { calendarView, theme in
            calendarView.calendar = Calendar(identifier: .gregorian)
            calendarView.locale = .current
            calendarView.timeZone = .current
            calendarView.fontDesign = .rounded
            calendarView.backgroundColor = .tertiarySystemBackground
            calendarView.tintColor = theme.colorPalette.button
            calendarView.availableDateRange = DateInterval(start: .distantPast, end: .now)
        }
    }
}
