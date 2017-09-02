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
        let bundle = Bundle(for: type(of: self))
        print(bundle)
        guard let resources: String = bundle.resourcePath else { return XCTFail("Can't find resource path") }
        let path = resources.appending("/response.html")
        print(path)
        let url = URL(fileURLWithPath: path)
        print(url)
        let data = try Data(contentsOf: url)
        XCTAssertNotNil(data)

//        let url = URL(fileURLWithPath: path)
//        print("URL:", url)
//        let data = try Data(contentsOf: url)
//
//        let result = try scrapper.parseHTML(data.makeString())
//        print("Result:", result)
//
//        XCTAssertEqual(result, "Friendskantine | Speiseplan - Bockenheim")


    }

    func testMeal() throws {
        // TODO: more tests
        let meal = Meal(category: .basic, details: "some food", price: 30.40)
        XCTAssertTrue(meal.category.rawValue == "basic")
    }
    
}
