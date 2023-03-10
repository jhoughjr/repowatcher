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
    static let shared = SSHManager(logger: nil)
    
    var clients = [String:SSHClient]()
    var logger:Logger? = nil
    
    init(logger:Logger?) {
        self.logger = logger
    }
    
    func startClient(config:SSHConfigurationFile.Config) async {
        do {
            logger?.info("starting client")
            let client = try await SSHClient.connect(
                host: config.host,
                authenticationMethod: .passwordBased(username: config.username,
                                                     password: config.password),
                hostKeyValidator: .acceptAnything(), // Please use another validator if at all possible, it's insecure
                reconnect: .never
            )
            client.onDisconnect {
                self.logger?.warning("disconnected")
                self.clients[config.url] = nil
            }
            clients[config.url] = client
        }
        catch {
            logger?.error("start client \(error.localizedDescription)")
        }

       
    }
    
    func run(_ command:String,
             with config:SSHConfigurationFile.Config) async {
        if clients[config.url] == nil {
            await startClient(config: config)
        }
        do {
            let buffer = try await clients[config.url]?.executeCommand(command)
            logger?.info("completed")
        }
        catch {
            self.logger?.error("run: \(error.localizedDescription)")
        }
    }
}
