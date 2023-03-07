import Vapor
import Queues
import QueuesRedisDriver

// configures your application
public func configure(_ app: Application) throws {
    let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(file)
    
    app.http.server.configuration.port = 9090

    // register routes
    try routes(app)
}
