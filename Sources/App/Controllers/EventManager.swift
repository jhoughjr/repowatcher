//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/27/23.
//

import Foundation
import Vapor
import SwiftShell
import Queues

class EventManager {
    typealias Config = ConfigurationFile.Config
    
    static let shared = EventManager(configs: nil, logger: nil, queue:nil)
    
    private var logger:Logger?
    var queue:Queue?
    
    var configs:[Config]?
    
    init(configs:[Config]?,
         logger:Logger?, queue:Queue?) {
        self.configs = configs
        self.logger = logger
        self.queue = queue
        self.logger?.info("configs: \(String(describing: configs))")
    }
    
    func handle(_ event:WebHookPayload) {
        logger?.info("handling \(event)")
        
        configs?.filter {$0.url == event.repository.url}
                .forEach { config in
                    
            if !config.script.isEmpty {
                Task {
                    do {
                        logger?.info("dispatching \(config.script)")
                        try await queue?.dispatch(ScriptJob.self,
                                                  ScriptJob.JobInfo(launchPath: config.localPath,
                                                          script: config.script))
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
