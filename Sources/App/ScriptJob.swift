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
    
    struct JobInfo:Codable {
        var script:String
        var launchPath:String
    }
    
    typealias Payload = JobInfo

    func dequeue(_ context: QueueContext,
                 _ payload: Payload) async throws {
        context.logger.info("script job running \(payload.script)")
            _ = shell(launchPath:payload.launchPath,
                      payload.script)
            context.logger.info("done")
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
        // If you don't want to handle errors you can simply return. You can also omit this function entirely.
        context.logger.error("\(error)")
    }
    
    @discardableResult
    func shell(launchPath:String, _ args: String...) -> Int32 {
        let task = Process()
        
        task.launchPath = launchPath
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}
