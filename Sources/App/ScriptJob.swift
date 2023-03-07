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
        do {
            _ = try self.runCommand(cmd: payload.script,
                                    args: [])
            context.logger.info("done")
        }
        catch {
            context.logger.error("\(error.localizedDescription)")
        }
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: Script) async throws {
        // If you don't want to handle errors you can simply return. You can also omit this function entirely.
        context.logger.error("\(error)")
    }
    
    func runCommand(cmd: String,
                    args: [String]) throws -> String {
       let outPipe = Pipe()
       let proc = Process()
       proc.launchPath = cmd
       let foo = args.map{$0.replacingOccurrences(of: "\r", with: "\n")}
       proc.arguments = foo
       proc.standardOutput = outPipe
       try proc.run()
       let data = outPipe.fileHandleForReading.readDataToEndOfFile()
       let res =  String(data: data, encoding: .utf8) ?? "ERROR"
       return res
   }

}
