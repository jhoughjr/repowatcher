//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/27/23.
//

import Foundation
import Vapor
import Queues

class EventManager {
    typealias RepoConfig = RepoConfigurationFile.Config
    typealias SSHConfig = SSHConfigurationFile.Config
    
    struct EventConfig:Codable {
        let repoConfig:RepoConfig
        let sshConfig:SSHConfig
    }
    
    
    
    static let shared = EventManager(configs: nil,
                                     logger: nil,
                                     queue:nil)
    
    private var logger:Logger?
    
    var queue:Queue?
    
    var configs:[EventConfig]?
    
    init(configs:[EventConfig]?,
         logger:Logger?,
         queue:Queue?) {
        self.configs = configs
        self.logger = logger
        self.queue = queue
        self.logger?.info("configs: \(String(describing: configs))")
        
    }
    
    func handle(_ event:WebHookPayload) {
        logger?.info("handling \(event)")
        
        configs?.filter {$0.repoConfig.url == event.repository.url}
                .forEach { config in
                    
                if !config.repoConfig.script.isEmpty {
                Task {
                    do {
                        logger?.info("dispatching \(config)")
                        try await queue?.dispatch(ScriptJob.self,
                                                  ScriptJob.JobInfo(sshConfig: config.sshConfig,
                                                                    script: config.repoConfig.script))
                        logger?.info("dispatched.")
                    }
                    catch {
                        logger?.error("\(error.localizedDescription)")
                    }
                }
            }
        }
        logger?.info("Done.")
    }
    
   
}
