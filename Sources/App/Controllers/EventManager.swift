//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/27/23.
//

import Foundation
import Vapor
import SwiftShell

class EventManager {
    typealias Config = ConfigurationFile.Config
    
    static let shared = EventManager(configs: nil, logger: nil)
    
    private var logger:Logger?
    
    var configs:[Config]?
    
    init(configs:[Config]?,
         logger:Logger?) {
        self.configs = configs
        self.logger = logger
        self.logger?.info("configs: \(configs)")
    }
    
    func handle(_ event:WebHookPayload) {
        logger?.info("handling \(event)")
        
        configs?.filter {$0.url == event.repository.url}
                .forEach { config in
                    
            if !config.script.isEmpty {
                Task {
                    do {
                        logger?.info("dispatching \(config.script)")
                        
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
