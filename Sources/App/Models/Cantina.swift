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

    // TODO: User
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

	final func currentDayMenu(_ format: TextFormat) throws -> String {
        guard let currentDay: DayName = DayName.current else {
            let error = Abort(.internalServerError, reason: "Could not identify current day")
            throw error
        }

        switch currentDay {
        case .saturday, .sunday:
            throw Abort(.notFound, reason: "It's weekend!")
        default:
			return try makeMenu(for: currentDay, format: format)
        }
    }

	final func makeMenu(for day: DayName, format: TextFormat) throws -> String {
        guard let currentDay = week.days[day] else {
            let error = Abort(.notFound, reason: "No menu for for the day found")
            throw error
        }

        return try currentDay.makeMenu(format)
    }
}
