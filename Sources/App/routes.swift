import Vapor

func routes(_ app: Application) throws {
    
    app.post("postEvents") { req async -> Response in
        
        guard let bod = req.body.data else {
            req.logger.error("no body data")
            return Response(status: .badRequest)
        }
        
        do {
//            let s = String(data:Data(buffer: bod,
//                                     byteTransferStrategy: .noCopy),encoding:.utf8)
//
//            req.logger.info("will decode \(String(describing:s))")
            let event = try JSONDecoder().decode(WebHookPayload.self,
                                                 from: bod)
            let file = ConfigurationFile(path: "./watched.json",
                                         logger: req.logger)
            
            EventManager(configs: file.configs,
                         logger: req.logger)
            .handle(event)
            
        }
        catch {
            req.logger.error("\(error)")
        }
        return Response(status: .ok)
    }
}
