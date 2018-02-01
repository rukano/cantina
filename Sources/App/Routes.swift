import Vapor

extension Droplet {
    func setupRoutes() throws {

        let cantina = CantinaController(drop: self)

		get("alexa", handler: cantina.alexa)

		get("text", handler: cantina.text)

        self.group(Verification(self)) { verified in
            verified.post("today", handler: cantina.today)
        }

    }
}
