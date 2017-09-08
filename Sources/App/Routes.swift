import Vapor

extension Droplet {
    func setupRoutes() throws {

        let cantina = CantinaController(drop: self)

        self.group(Verification()) { verified in
            verified.get("today", handler: cantina.today)
        }

    }
}
