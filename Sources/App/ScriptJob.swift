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
            context.logger.info("done running.")
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
        // If you don't want to handle errors you can simply return. You can also omit this function entirely.
        context.logger.error("\(error)")
    }
    
    @discardableResult
    func shell(launchPath:String, _ args: String) -> String {
        
        let shell = Shell()

        do {
            // Shell is implemented with `callAsFunction`.
            let chDir = try shell("cd \"\(launchPath)\"", arguments: [])
            print(chDir)
            let run = try shell(args)
            return run
        } catch {
            print(error)
        }
        return ""
    }
}
