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
            let setPath = "cd \(payload.launchPath);"
            _ = shell(setPath + payload.script)
            context.logger.info("done")
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
        // If you don't want to handle errors you can simply return. You can also omit this function entirely.
        context.logger.error("\(error)")
    }
    
    @discardableResult
    func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath =
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
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
