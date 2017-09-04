//
//  Date+Extensions.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 03.09.17.
//
//

import Foundation

extension Date {
    static var currentWeek: Int {
        return Calendar.current.component(.weekOfYear, from: Date())
    }

    static var currentWeekDay: Int {
        return Calendar.current.component(.weekday, from: Date())
    }

    static var currentWeekDayIdentifier: String {
        let format = DateFormatter()
        format.dateFormat = "EEEE"
        format.locale = Locale(identifier: "de_DE")
        return format.string(from: Date())
    }

}
