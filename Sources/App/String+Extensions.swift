//
//  String+Extensions.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 03.09.17.
//
//

import Foundation
import Vapor

extension String {
    func removingDoubleSpaces() -> String {
        var str: String = self.replacingOccurrences(of: "  ", with: " ")
        if str.contains("  ") {
            str = str.removingDoubleSpaces()
        }
        return str
    }
}
