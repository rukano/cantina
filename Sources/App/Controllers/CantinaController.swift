//
//  CantinaController.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 02.09.17.
//
//

import Vapor
import Kanna

enum TextFormat {
	case mattermost
	case prosa
}

final class CantinaController {

    private let externalUrl: String = "http://www.friendskantine.de/index.php/speiseplan/speiseplan-bockenheim"
    var drop: Droplet

    init(drop: Droplet) {
        self.drop = drop
    }

	func alexa(_ req: Request) throws -> ResponseRepresentable {
		return try requestMenuText(.prosa)
	}

    func text(_ req: Request) throws -> ResponseRepresentable {
        return try requestMenuText(.mattermost)
    }

    func today(_ req: Request) throws -> ResponseRepresentable {
        let text = try requestMenuText(.mattermost)
        return try CantinaMattermost(text).makeJson()
    }

	private func requestMenuText(_ format: TextFormat) throws -> String {
        let response = try drop.client.request(.get, externalUrl)

        guard let bytes = response.body.bytes else {
            throw Abort.serverError
        }

        let content = String(bytes: bytes)
        let cantina = try Cantina(fromWeb: content)
        let text = try cantina.currentDayMenu(format)
        return text
    }

}
