//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/27/23.
//

import Foundation
import Vapor
class EventManager {
    static let shared = EventManager(file: nil, logger: nil)
    
    private var logger:Logger?
    
    var file:ConfigurationFile?
    
    init(file:ConfigurationFile?, logger:Logger?) {
        self.file = file
        self.logger = logger
    }
    
    func handle(_ event:WebHookPayload) {
        guard let file = file else {
            return
        }
        file.configs.filter {$0.url == event.repository.url}
                    .forEach { config in
                        
            if !config.script.isEmpty {
                DispatchQueue.main.async {
                    do {
                        let result = try self.runCommand(cmd: config.script, args: [""])
                        self.logger?.info("result \(result)")
                    }
                    catch {
                        self.logger?.error("\(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
     func runCommand(cmd: String,
                     args: [String]) throws -> String {
        let outPipe = Pipe()
        let proc = Process()
        proc.launchPath = cmd
        let foo = args.map{$0.replacingOccurrences(of: "\r", with: "\n")}
        proc.arguments = foo
        proc.standardOutput = outPipe
//        proc.launch()
//        proc.waitUntilExit()

        try proc.run()
        let data = outPipe.fileHandleForReading.readDataToEndOfFile()
        let res =  String(data: data, encoding: .utf8) ?? "ERROR"
        //should trim?
        return res
    }
}
