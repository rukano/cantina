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

    func today(_ req: Request) throws -> ResponseRepresentable {
        let response = try drop.client.request(.get, externalUrl)

        guard let bytes = response.body.bytes else {
            throw Abort.serverError
        }

        let content = String(bytes: bytes)
        let cantina = try Cantina(fromWeb: content)
//        let text = try cantina.makeMenu(for: DayName.current)
        let text = try cantina.currentDayMenu()

        return try CantinaMattermost(text).makeJson()
    }

}
