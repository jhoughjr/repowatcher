import Vapor
import Queues
import QueuesRedisDriver

// configures your application
public func configure(_ app: Application) throws {
    let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(file)
    
    try app.queues.use(.redis(url: "redis://127.0.0.1:6379"))
    app.http.server.configuration.port = 9090
    
    // register routes
    try routes(app)
}
