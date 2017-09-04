//
//  Cantina+Scrapper.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 02.09.17.
//
//

import Vapor
import Kanna

typealias MaybeMealData = (title: String, price: String, details: String)
typealias MaybeWeek = XMLElement
typealias MaybeDay = XMLElement
typealias MaybeMeal = XMLElement
typealias MaybeWeekMenu = [String:[MaybeMealData]]

/// Extracts the useful items from HTML/CSS
final class CantinaHTML {

    var document: HTMLDocument

    init(fromWebContent string: String) throws {
        guard let html = HTML(html: string, encoding: .utf8) else {
            let error = Abort(.badRequest, reason: "Can't parse HTML from string")
            throw error
        }
        document = html
    }

    var title: String? {
        return document.title
    }

    /// Gets the menu for the whole week
    var week: MaybeWeek? {
        return document.css("div.SP_Speiseplan").first
    }

    /// Gets the week number and the date range
    var date: String? {
        return week?.css("div.Datum").first?.text
    }

    /// Gets a list of the days with it's elements
    var days: [MaybeDay]? {
        return week?.css("div.SP_Day").array
    }

    /// Gets the name of the week (h3)
    func getDayName(_ day: MaybeDay) -> String? {
        return day.css("h3").first?.text
    }

    /// Gets the meals in the list for the day
    func getDayMeals(_ day: MaybeDay) -> [MaybeMeal]? {
        return day.css("div.menu-items ul li").array
    }

    /// Gets the meal data from object and pust it into a tuple of 3 optional strings
    func getMeal(_ meal: MaybeMeal) -> MaybeMealData? {
        let title = meal.css("div.foodtitle").first?.text
        let price = meal.css("div.foodprice").first?.text
        let details = meal.css("div.description").first?.text

        if (title ?? price ?? details) == nil { return nil }

        return (title ?? "", price ?? "", details ?? "")
    }

    func mealsForDay(_ day: MaybeDay) -> [MaybeMealData] {
        guard let meals = getDayMeals(day) else { return [] }
        return meals.flatMap{ meal in getMeal(meal) }
    }

    func mealsForWeek() -> MaybeWeekMenu {
        var weekMeals: MaybeWeekMenu = [:]

        guard let days = days else { fatalError("No days to parse") }

        for day in days {
            guard let dayName: String = getDayName(day) else { continue }
            var dayMeals: [MaybeMealData] = []
            if let meals = getDayMeals(day) {
                for meal in meals {
                    guard let mealData: MaybeMealData = getMeal(meal) else { continue }
                    dayMeals.append(mealData)
                }
            }
            weekMeals[dayName] = dayMeals
        }

        return weekMeals
    }

    var weekData: (date: String, menu: MaybeWeekMenu)? {
        guard let date = date else { return nil }
        return (date, mealsForWeek())
    }

    func makeWeek() throws -> Week? {
        guard let weekData = weekData else {
            let error = Abort(.internalServerError, reason: "No week data found")
            throw error
        }

        // Build Week components
        guard let weekComponents = Week.splitComponents(weekData.date) else {
            let error = Abort(.internalServerError, reason: "Could not load week components")
            throw error
        }

        let weekNumber = weekComponents.number
        let weekRange = weekComponents.range

        var days: [DayName:Day] = [:]

        for (dayName, dayMeals) in weekData.menu {
            guard let day = try makeDay(dayName, menu: dayMeals) else { continue }
            days[day.name] = day
        }

        return Week(number: weekNumber, range: weekRange, days: days)
    }
    
    func makeDay(_ name: String, menu: [MaybeMealData]) throws -> Day? {
        guard let dayName: DayName = DayName(rawValue: name) else {
            let error = Abort(.internalServerError, reason: "Could not make day")
            throw error
        }

        var meals: [MealType:Meal] = [:]
        for mealData in menu {
            let meal = try makeMeal(mealData)
            meals[meal.type] = meal
        }

        return Day(name: dayName, meals: meals)
    }
    
    func makeMeal(_ meal: MaybeMealData) throws -> Meal {
        let priceString = meal.price.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let priceNumber: String = priceString.components(separatedBy: " ").first else {
            let error = Abort(.internalServerError, reason: "Could not make price")
            throw error
        }

        let priceFormatted: String = priceNumber.replacingOccurrences(of: ",", with: ".").trim()
        guard let priceFloat: Float = Float(priceFormatted) else {
            let error = Abort(.internalServerError, reason: "Could not make price floav value")
            throw error
        }

        return Meal(type: MealType.from(title: meal.title), details: meal.details, price: priceFloat)
    }
    
    
}
