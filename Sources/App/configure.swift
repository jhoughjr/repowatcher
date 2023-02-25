import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.http.server.configuration.port = 9090

    // register routes
    try routes(app)
}
