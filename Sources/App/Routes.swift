import Vapor

extension Droplet {
    func setupRoutes() throws {

        let cantina = CantinaController(drop: self)

        get("today", handler: cantina.today)
    }
}
