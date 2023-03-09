//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 3/8/23.
//

import Foundation
import Citadel
import Vapor

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
            client = try await SSHClient.connect(
                host: "example.com",
                authenticationMethod: .passwordBased(username: "joannis", password: "s3cr3t"),
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
            buffer = try await client?.executeCommand(command)
            logger?.info("\(buffer)")
            
        }
        catch {
            self.logger?.error("\(error)")
        }
    }
}
