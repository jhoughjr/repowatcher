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
    
    struct JobInfo: Codable {
        let launchPath:String
        let script:String
    }
    
    typealias Payload = JobInfo

    func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
        context.logger.info("dequeueing...")
       
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
        // If you don't want to handle errors you can simply return. You can also omit this function entirely.
        context.logger.error("\(error)")
    }
    
    
}
