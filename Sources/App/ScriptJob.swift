//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 3/6/23.
//

import Vapor
import Foundation
import Queues
import SwiftShell

struct ScriptJob: AsyncJob {
    typealias Payload = String

    func dequeue(_ context: QueueContext, _ payload: String) async throws {
        // This is where you would send the email
    }

    func error(_ context: QueueContext, _ error: Error, _ payload: String) async throws {
        // If you don't want to handle errors you can simply return. You can also omit this function entirely.
    }
}
