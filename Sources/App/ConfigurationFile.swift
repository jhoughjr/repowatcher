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
struct ConfigurationFile {
    
    struct Config:Codable {
        let url:String
        let script:String
    }
    
    var configs = [Config]()
    private var logger:Logger? = nil
    
    init(path:String, logger:Logger?) {
        self.logger = logger
        
        if logger != nil {
            logger!.info("loading \(path)")
        }
        if let loadedData = FileManager.default.contents(atPath: path) {
            do {
                let configs = try JSONDecoder().decode([Config].self,
                                                       from: loadedData)
                self.configs = configs
                
                self.logger?.info("loaded \(self.configs)")
                
            }
            catch {
                if logger != nil {
                    logger!.error("\(error)")
                }
            }
        }
    }
}
