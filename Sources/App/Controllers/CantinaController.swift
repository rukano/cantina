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

    var drop: Droplet

    init(drop: Droplet) {
        self.drop = drop
    }

    func today(_ req: Request) throws -> ResponseRepresentable {
        let url = "http://www.friendskantine.de/index.php/speiseplan/speiseplan-bockenheim"
        let response = try drop.client.request(.get, url)

        guard let bytes = response.body.bytes else {
            throw Abort.serverError
        }

        let content = String(bytes: bytes)
        let cantina = try Cantina(fromWeb: content)
        return try cantina.currentDayMenu()
    }

}
