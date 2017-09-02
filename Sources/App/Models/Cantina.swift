//
//  Cantina.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 02.09.17.
//
//

import Vapor

enum MealCategory: String {
    case soup
    case basic
    case special
    case salad
    case vegetarian
    case unknown

    static func from(title: String) -> MealCategory {
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
    var category: MealCategory
    var details: String
    var price: Float

    var description: String { return details }
}

enum WorkingDay: Int {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
}

struct Day {
    var day: WorkingDay
    var date: Date
    var name: String
    var meals: [MealCategory:Meal]
}

struct Week {
    var number: Int
    var range: String
    var days: [WorkingDay: Day]
}
