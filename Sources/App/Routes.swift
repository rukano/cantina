import Vapor

extension Droplet {
    func setupRoutes() throws {

        let cantina = CantinaController(drop: self)

        self.group(Verification(self)) { verified in
            verified.post("today", handler: cantina.today)
        }

    }
}
