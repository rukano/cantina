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

    func testHTMLScrapping() throws {
        print("======================================================================\n\n\n\n\n\n\n\n\n")
        print("Testing HTML scrapping\n")
        let path = Bundle(for: type(of: self)).path(forResource: "response", ofType: "html")
        let url = URL(fileURLWithPath: path!)
        let data = try Data(contentsOf: url)
        XCTAssertNotNil(data)
        let cantina = try Cantina(fromWeb: data.makeString())
        print(cantina)
        print(try cantina.makeMenu(for: .monday))

        print("\n\n\n\n\n\n\n\n\n======================================================================")
    }
}
