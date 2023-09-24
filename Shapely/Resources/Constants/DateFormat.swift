//
//  DateFormat.swift
//  Vladlink
//
//  Created by Pavel Zorin on 27.02.2021.
//

import Foundation

enum DateFormat: String {
    case sendAgainTimer = "mm:ss"
    case date = "dd.MM.yyyy"
    case serverDate = "yyyy-MM-dd"
    case normal = "yyyy-MM-dd hh:mm:ss"
    case result = "hh:mm:ss"
    case time = "HH:mm"
    case timeSecond = "ss"
    case dateForLongMonth = "d MMM yyyy"
    case dateFullMonth = "d MMMM yyyy"
    case dateFullMonthAndTIme = "d MMMM yyyy, HH:mm"
    case shortDateAndTime = "dd.MM.yyyy HH:mm"
}
