import Vapor

extension Droplet {
    func setupRoutes() throws {

        let cantina = CantinaController(drop: self)

        post("today", handler: cantina.today)
    }
}
