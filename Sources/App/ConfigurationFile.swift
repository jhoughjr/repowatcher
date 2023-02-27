//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/27/23.
//

import Foundation
import Vapor

/**
 [
    { "url":"",
     "script": "git pull;sudo docker compose build;sudo docker compose up "},
    ...
 
 */
import NIO
class ConfigurationFile {
    
    struct Config:Codable {
        let url:String
        let script:String
    }
    
    var path:String = ""
    var configs = [Config]()
    
    private var logger:Logger? = nil
    private var io:FileIO
    
    init(fileIO:FileIO,
         path:String,
         logger:Logger?) {
        self.io = fileIO
        self.logger = logger
        self.path = path
    }
    
    func load() async {
        
        if logger != nil {
            logger!.info("loading \(path)")
        }
            let res = io.streamFile(at: path)
            if let chunk = res.body.buffer {
                eatChunk(chunk: chunk)
            }
            
    }
    
    func eatChunk(chunk:ByteBuffer) {
        do {
            let configs = try JSONDecoder().decode([Config].self,
                                                   from: Data(buffer: chunk,
                                                              byteTransferStrategy: .automatic))
            self.configs = configs
            
            self.logger?.info("loaded \(self.configs)")
            
        }
        catch {
            if self.logger != nil {
                self.logger!.error("\(error)")
            }
        }
    }
    
}
