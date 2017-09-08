//
//  Cantina+Mattermost.swift
//  cantina
//
//  Created by Romero, Juan, SEVEN PRINCIPLES on 09.09.17.
//
//

import Foundation

struct CantinaMattermost {
    let iconUrl = "http://friends-kantine.herokuapp.com/cantina_icon.png"
    let responseType = "in_channel"
    var text: String

    init(_ text: String) {
        self.text = text
    }

    func makeJson() throws -> JSON {
        var json = JSON()
        try json.set("text", text)
        try json.set("icon_url", iconUrl)
        try json.set("response_type", responseType)
        return json
    }
}
