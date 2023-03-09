import Vapor

func routes(_ app: Application) throws {
    
    app.post("postEvents") { req async -> Response in
        
        guard let bod = req.body.data else {
            req.logger.error("no body data")
            return Response(status: .badRequest)
        }
        
        // decode
        
        do {
            
            let event = try JSONDecoder().decode(WebHookPayload.self,
                                                 from: bod)
            
            let workingDir = app.directory.resourcesDirectory

            let repoFile = RepoConfigurationFile(fileIO:req.fileio,
                                         path: workingDir + "watched.json",
                                         logger: req.logger)
            await repoFile.load()
            
            let sshFile = SSHConfigurationFile(fileIO: req.fileio,
                                               path: workingDir + "ssh.json",
                                               logger: req.logger)
            await sshFile.load()
            
            guard let repoConfig = repoFile.configs.first(where:{ f in
                f.url == event.repository.url
            })
            else {
                return Response(status: .ok)
            }
            
            guard let sshConfig = sshFile.configs.first(where:{ f in
                f.url == event.repository.url
            })
            else {
                return Response(status: .failedDependency)
            }
            
            EventManager(configs:[EventManager.EventConfig(repoConfig: repoConfig,
                                                           sshConfig: sshConfig)],
                         logger: req.logger,
                         queue:req.queue)
            .handle(event)
            
        }
        catch {
            req.logger.error("\(error)")
        }
        return Response(status: .ok)
    }
}
