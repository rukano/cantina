//
//  Cantina+Elements.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 02.09.17.
//
//

import Foundation
import Vapor

enum MealType: String {
	case soup = "Suppe"
	case basic = "Stammessen"
	case special = "Aktion"
	case salad = "Salat"
	case vegetarian = "Vegetarisch"
	case unknown = "???"

	var emoji: String {
		switch self {
		case .soup: return ":stew:"
		case .basic: return ":spaghetti:"
		case .salad: return ":tomato:"
		case .vegetarian: return ":pineapple:"
		case .special: return ":curry:"
		case .unknown: return "dizzy_face"
		}
	}

	static func from(title: String) -> MealType {
		switch title {
		case "Suppen / Eintöpfe": return .soup
		case "Stammessen": return .basic
		case "Großer Salatteller": return .salad
		case "Aktion": return .special
		case "Vegetarisch": return .vegetarian
		default: return .unknown
			// TODO: handle unknown titles
		}
	}
}

struct Meal: CustomStringConvertible {
	var type: MealType
	var details: String
	var price: Float

	var description: String { return details }
}

enum DayName: String {
	case monday = "Montag"
	case tuesday = "Dienstag"
	case wednesday = "Mittwoch"
	case thursday = "Donnerstag"
	case friday = "Freitag"
	case saturday = "Samstag"
	case sunday = "Sonntag"

	static var current: DayName? {
		return DayName(rawValue: Date.currentWeekDayIdentifier)
	}
}

struct Day {
	var name: DayName
	var meals: [MealType:Meal]

	var tableHeader: String {
		let header: String = "|Art  |Gericht|Preis|"
		let format: String = "|:----|:------|:---:|"
		return [header, format].joined(separator: "\n")
	}

	func makeMenu(_ format: TextFormat) throws -> String {
		switch format {
		case .mattermost:
			return try makeMattermostMenu()
		case .prosa:
			return try makeAlexaMenu()
		}
	}

	private func makeAlexaMenu() throws -> String {
		let dayHeader: String = "Heute, am \(name.rawValue) gibt es:"
		var mealRows: [String] = []
		let orderedMeals: [MealType] = [.basic, .special, .vegetarian]

		for mealType in orderedMeals {
			var mealArray: [String] = []
			guard let meal = meals[mealType] else { continue }

			let title = mealType.rawValue
			var details = meal.description.replacingOccurrences(of: "\r", with: " ")
			details = details.replacingOccurrences(of: "\n", with: " ")
			details = details.replacingOccurrences(of: "- ", with: "-")
			details = details.removingDoubleSpaces().trimmingCharacters(in: .whitespacesAndNewlines)
			mealArray.append("\(title)")
			mealArray.append("\(details)")
			let row: String = "\(mealArray.joined(separator: " ist "))"
			mealRows.append(row)
		}

		let text: String = "\(dayHeader)\n\(mealRows.joined(separator: ". "))\nUnd wie immer, Suppe oder Salat"
		return text
	}

	private func makeMattermostMenu() throws -> String {
		let dayHeader: String = "### \(name.rawValue)"
		var mealRows: [String] = []
		let orderedMeals: [MealType] = [.soup, .basic, .special, .vegetarian, .salad]

		for mealType in orderedMeals {
			var mealArray: [String] = []
			guard let meal = meals[mealType] else { continue }

			let title = mealType.emoji
			let price = String(format: "%.2f €", meal.price).replacingOccurrences(of: ".", with: ",")
			var details = meal.description.replacingOccurrences(of: "\r", with: " ")
			details = details.replacingOccurrences(of: "\n", with: " ")
			details = details.removingDoubleSpaces().trimmingCharacters(in: .whitespacesAndNewlines)

			if mealType == .soup { details = ":ramen: :ramen: :ramen:" }

			mealArray.append("\(title)")
			mealArray.append("\(details)")
			mealArray.append("\(price)")

			let row: String = "| \(mealArray.joined(separator: " | ")) |"
			mealRows.append(row)
		}

		let table: String = "\(dayHeader)\n\(tableHeader)\n\(mealRows.joined(separator: "\n"))"
		return table
	}
}

struct Week {
	var number: Int
	var range: String
	var days: [DayName: Day]

	static func splitComponents(_ string: String) -> (number: Int, range: String)? {
		let components = string.components(separatedBy: "//").map{ $0.trim() }
		let header = components[0]
		let weekRange = components[1]

		guard let weekString = Week.number(from: header), let weekNumber = Int(weekString) else {
			return nil
		}

		return (weekNumber, weekRange)
	}

	static func number(from string: String) -> String? {
		let components: [String] = string.components(separatedBy: " ")
		return components.last
	}

	func makeMenu(format: TextFormat) throws -> String {
		var weekArray: [String] = []
		for (_, day) in days {
			let row = try day.makeMenu(format)
			weekArray.append(row)
		}
		return weekArray.joined(separator: "\n\n---\n\n")
	}

}


