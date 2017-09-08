//
//  Verification.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 08.09.17.
//
//

import Vapor

final class Verification: Middleware {

    var drop: Droplet

    init(_ drop: Droplet) {
        self.drop = drop
    }

    func respond(to request: Request, chainingTo next: Responder) throws -> Response {

        drop.log.info("Request query: \(request.description)")

        guard let mm_token: String = Env.get("MM_TOKEN") else {
            fatalError("No local token given")
        }

        guard let token = request.query?["token"]?.string, token == mm_token else {
            throw Abort.unauthorized
        }

        return try next.respond(to: request)
    }
}
