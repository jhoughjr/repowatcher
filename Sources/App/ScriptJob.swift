//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 3/6/23.
//

import Vapor
import Foundation
import Queues

struct ScriptJob: AsyncJob {
    
    struct Script:Codable {
        var script:String
    }
    
    typealias Payload = Script

    func dequeue(_ context: QueueContext, _ payload: Script) async throws {
        context.logger.info("running \(payload.script)")
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: Script) async throws {
        // If you don't want to handle errors you can simply return. You can also omit this function entirely.
        context.logger.error("\(error)")
    }
}
