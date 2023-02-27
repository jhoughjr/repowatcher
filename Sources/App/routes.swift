import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.post("postEvents") { req async-> Response in
        guard let bod = req.body.data else {
            return Response(status: .badRequest)
        }
        
        do {
            let s = String(data:Data(buffer: bod,
                                     byteTransferStrategy: .noCopy),encoding:.utf8)
            
            req.logger.info("will decode \(String(describing:s))")
            let event = try JSONDecoder().decode(WebHookPayload.self,
                                                 from: bod)
            req.logger.info("\(event)")
            
        }
        catch {
            req.logger.error("\(error)")
        }
        return Response(status: .ok)
    }
}
