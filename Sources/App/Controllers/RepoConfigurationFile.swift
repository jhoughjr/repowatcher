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
class RepoConfigurationFile {
    
    struct Config:Codable {
        let url:String
        let script:String
        let localPath:String
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
        
        do {
            let res =  try await io.collectFile(at: path)
            eatChunk(chunk: res)
        }
        catch {
            logger?.error("\(error)")
        }
       
            
    }
    
    func eatChunk(chunk:ByteBuffer) {
        logger?.info("decoding")
        do {
            let configs = try JSONDecoder().decode([Config].self,
                                                   from: Data(buffer: chunk,
                                                              byteTransferStrategy: .automatic))
            self.configs = configs
            
            self.logger?.info("decoded \(self.configs)")
            
        }
        catch {
            if self.logger != nil {
                self.logger!.error("\(error)")
            }
        }
    }
    
}
