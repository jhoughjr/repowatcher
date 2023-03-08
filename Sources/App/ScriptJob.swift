//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 3/6/23.
//

import Vapor
import Foundation
import Queues
import SwiftShell

struct ScriptJob: AsyncJob {
    
    struct JobInfo: Codable {
        let launchPath:String
        let script:String
    }
    
    typealias Payload = JobInfo

    func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
        context.logger.info("dequeueing...")
        shell(context:context,
              launchPath: payload.launchPath, payload.script)
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
        // If you don't want to handle errors you can simply return. You can also omit this function entirely.
        context.logger.error("\(error)")
    }
    
    @discardableResult
    func shell(context:QueueContext,
               launchPath:String, _ args: String) -> String {
        
        let shell = Shell()

        do {
            // Shell is implemented with `callAsFunction`.
            let chDir = try shell("cd \"\(launchPath)\"", arguments: [])
            context.logger.info("\(chDir)")
            let run = try shell(args)
            return run
        } catch {
            context.logger.error("\(error)")
        }
        return ""
    }
}
