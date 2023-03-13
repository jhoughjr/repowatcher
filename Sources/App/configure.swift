import Vapor
import Queues
import QueuesRedisDriver

// configures your application
public func configure(_ app: Application) throws {
    let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(file)
    
    app.logger.info("serving files @ \(app.directory.publicDirectory)")
    
    
    // need to grab redis from some config
    
//    InternalConfigurationFile(fileIO: app.,
//                              path: "",
//                              logger: app.logger)
    
    try app.queues.use(.redis(url: "redis://redis:6379"))
    app.queues.add(ScriptJob())
    
    app.logger.info("queues configured/")

    app.http.server.configuration.port = 9090

    // register routes
    try routes(app)
}
