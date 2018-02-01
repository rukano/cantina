//
//  Verification.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 08.09.17.
//
//

import Vapor
import HTTP
import Fluent

final class Verification: Middleware {

    var drop: Droplet

    init(_ drop: Droplet) {
        self.drop = drop
    }

    func respond(to request: Request, chainingTo next: Responder) throws -> Response {

        drop.log.info(request.description)
        let dict = try convertToDictionary(request.body)

        guard let mm_token: String = Env.get("MM_TOKEN") else {
            fatalError("No local token given")
        }

        guard let token = dict["token"], token == mm_token else {
            throw Abort.unauthorized
        }

        return try next.respond(to: request)
    }

    private func convertToDictionary(_ body: Body) throws -> [String:String] {
        var dict: [String:String] = [:]
        guard let bytes = body.bytes else { throw Abort.serverError }
        let content = String(bytes: bytes)
        let elements: [String] = content.components(separatedBy: "&")
        let keyValues: [[String]] = elements.map{ $0.components(separatedBy: "=") }
        keyValues.forEach{ (pair: [String]) in
            dict[pair[0]] = pair[1]
        }
        return dict
    }


}
