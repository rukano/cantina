//
//  Verification.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 08.09.17.
//
//

import Vapor

final class Verification: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard let authKey = request.headers["AuthKey"], authKey == "$AUTH_KEY" else {
            throw Abort.unauthorized
        }
        return try next.respond(to: request)
    }
}
