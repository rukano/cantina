//
//  CantinaTests.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 02.09.17.
//
//

import XCTest
import Testing
import HTTP
import Sockets
@testable import Vapor
@testable import App

class CantinaTests: TestCase {

    let drop = try! Droplet.testable()
    let scrapper: CantinaController = CantinaController()

    func testHTMLScrapping() throws {
        print("Testing HTML scrapping\n")
        let path = Bundle(for: type(of: self)).path(forResource: "response", ofType: "html")!
        let data = try Data.init(contentsOf: URL(fileURLWithPath: path))
        XCTAssertNotNil(data)

        let str = try scrapper.parseHTML(data.makeString())
        print("Result:", str)

    }

    func testMeal() throws {
        // TODO: more tests
        let meal = Meal(category: .basic, details: "some food", price: 30.40)
        XCTAssertTrue(meal.category.rawValue == "basic")
    }

}
