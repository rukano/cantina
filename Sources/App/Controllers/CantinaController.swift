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

    private let externalUrl: String = "http://www.friendskantine.de/index.php/speiseplan/speiseplan-bockenheim"
    var drop: Droplet

    init(drop: Droplet) {
        self.drop = drop
    }

    func text(_ req: Request) throws -> ResponseRepresentable {
        return try requestMenuText()
    }

    func today(_ req: Request) throws -> ResponseRepresentable {
        let text = try requestMenuText()
        return try CantinaMattermost(text).makeJson()
    }

    private func requestMenuText() throws -> String {
        let response = try drop.client.request(.get, externalUrl)

        guard let bytes = response.body.bytes else {
            throw Abort.serverError
        }

        let content = String(bytes: bytes)
        let cantina = try Cantina(fromWeb: content)
        let text = try cantina.currentDayMenu()
        return text
    }

}
