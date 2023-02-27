//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/27/23.
//

import Foundation

/**
 [
    { "url":"",
     "script": "git pull;sudo docker compose build;sudo docker compose up "},
    ...
 
 */
struct ConfigurationFile:Codable {
    
    struct Config:Codable {
        let url:String
        let script:String
    }
    
    var configs = [Config]()
    
}
