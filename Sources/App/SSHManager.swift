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
                reconnect: .always
            )
            client.onDisconnect {
                self.logger?.warning("disconnected")
                self.clients[config.url] = nil
            }
            clients[config.url] = client
            logger?.info("client connected ? \(client.isConnected)")
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
            
            logger?.info("collecting streams...")
            let streams = try await clients[config.url]?.executeCommandStream(command)
            logger?.info("makign interator for streams...")

            var asyncStreams = streams?.makeAsyncIterator()
            logger?.info("interating streams...")
            while let blob = try await asyncStreams?.next() {
                switch blob {
                    case .stdout(let stdout):
                        // do something with stdout
                    logger?.info("OUYT: \(stdout.getString(at: 0, length: stdout.readableBytes))")
                case .stderr(let stderr):
                        // do something with stderr
                    logger?.error("ERR: \(stderr.getString(at: 0, length: stderr.readableBytes))")
                }
            }
            
            logger?.info("completed")
        }
        catch {
            self.logger?.error("run: \(error.localizedDescription)")
        }
    }
}
