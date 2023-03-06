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
    typealias Config = ConfigurationFile.Config
    
    static let shared = EventManager(configs: nil, logger: nil)
    
    private var logger:Logger?
    
    var configs:[Config]?
    var queue:Queue?
    
    init(configs:[Config]?, logger:Logger?) {
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
                        try await queue?.dispatch(ScriptJob.self,
                                                  .init(script:config.script))
                    }
                    catch {
                        self.logger?.error("\(error.localizedDescription)")
                    }
                }
            }
        }
        logger?.info("Done.")
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
