//
//  Cantina.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 03.09.17.
//
//

import Vapor

final class Cantina {

    final var week: Week
    final var isDataCurrent: Bool {
        return week.number >= Date.currentWeek
    }

    init(fromWeb string: String) throws {
        guard let week = try CantinaHTML(fromWebContent: string).makeWeek() else {
            let error = Abort(.internalServerError, reason: "Could not load data for the week")
            throw error
        }

        self.week = week
    }

    final func currentDayMenu() throws -> String {
        guard let currentDay: DayName = DayName.current else {
            let error = Abort(.internalServerError, reason: "Could not identify current day")
            throw error
        }

        // FIXME: Remove this when deploying!
        guard !(currentDay == .saturday || currentDay == .sunday) else {
            throw Abort(.notFound, reason: "It's weekend!")
        }

//        if !isDataCurrent {
//            // TODO: Print warning in response
//            print("WARNING: Data is not current!!!!!!!!!!")
//        }

        return try makeMenu(for: currentDay)
    }

    final func makeMenu(for day: DayName) throws -> String {
        guard let currentDay = week.days[day] else {
            let error = Abort(.notFound, reason: "No menu for for the day found")
            throw error
        }

        return try currentDay.makeMenu()
    }
}
