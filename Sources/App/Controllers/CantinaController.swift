//
//  CantinaController.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 02.09.17.
//
//

import Vapor
import Kanna

final class CantinaController {

    func parseHTML(_ html: String) throws -> String {
        guard let doc = HTML(html: html, encoding: .utf8) else {
            let error = Abort(.badRequest, reason: "Can't parse HTML from string")
            throw error
        }
        return doc.title!
    }

}
