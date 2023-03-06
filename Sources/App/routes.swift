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
            let workingDir = app.directory.resourcesDirectory
            let path = "../../Resources/"

            let file = ConfigurationFile(fileIO:req.fileio,
                                         path: workingDir + "watched.json",
                                         logger: req.logger)
            await file.load()
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
