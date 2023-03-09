//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 2/24/23.
//


import Foundation
import Vapor

struct WebHookPayload:Codable  {

    enum CodingKeys: String, CodingKey {
        case ref
        case before
        case after
        case repository
        case pusher
        case sender
        case created
        case deleted
        case forced
        case baseRef
        case compare
        case commits
        case headCommit = "head_commit"
    }
    
    var ref:String
    var before:String
    var after:String
    var repository:Repository
    var pusher:Pusher
    var sender:Sender
    var created:Bool
    var deleted:Bool
    var forced:Bool
    var baseRef:String?
    var compare:String
    var commits:[Commit]
    var headCommit:Commit
    
    
}
