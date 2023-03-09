//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 3/8/23.
//

import Foundation
import Citadel
import Vapor
import AsyncAlgorithms

class SSHManager {
    static let shared = SSHManager(nil, logger: nil)
    
    var client:SSHClient? = nil
    var config:SSHConfigurationFile.Config? = nil
    var logger:Logger? = nil
    var buffer:ByteBuffer? = nil
    
    init(_ config:SSHConfigurationFile.Config?,
         logger:Logger?) {
        self.config = config
        self.logger = logger
        Task {
            self.logger?.info("connecting \(config) ...")
            await startClient()
        }
    }
    
    func startClient() async {
        do {
            logger?.info("starting client")
            client = try await SSHClient.connect(
                host: config?.url ?? "",
                authenticationMethod: .passwordBased(username: config?.username ?? "",
                                                     password: config?.password ?? ""),
                hostKeyValidator: .acceptAnything(), // Please use another validator if at all possible, it's insecure
                reconnect: .never
            )
        }
        catch {
            logger?.error("\(error)")
        }

        client?.onDisconnect {
            self.logger?.warning("disconnected")
        }
    }
    
    func run(_ command:String) async {
        do {
            logger?.info("running \(command) @ \(config?.url) as \(config?.username)")
            buffer = try await client?.executeCommand(command)
            if let b = buffer {
                let str =  String(buffer: b)
                str.enumerateLines { line, stop in
                    self.logger?.info("\(line)")
                }
            }
        }
        catch {
            self.logger?.error("\(error)")
        }
    }
}
