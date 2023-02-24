import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.post("postEvents") { req in
        let bod = "\(req.body)"
        req.logger.info("\(bod)")
        return bod
    }
}
