import Vapor
import Queues
import QueuesRedisDriver

// configures your application
public func configure(_ app: Application) throws {
    let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(file)
    
    try app.queues.use(.redis(url: "redis://redis:6379"))
    app.http.server.configuration.port = 9090
    app.queues.add(ScriptJob())
    try app.queues.startInProcessJobs(on: .default)

    // register routes
    try routes(app)
}
