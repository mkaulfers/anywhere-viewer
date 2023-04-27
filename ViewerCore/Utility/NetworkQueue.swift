//
//  NetworkQueue.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import Foundation

/**
 `NetworkQueue` is a class that provides a queue for network requests, limiting the number of concurrent tasks.
 */
class NetworkQueue {
    
    /// The underlying queue for handling network requests.
    private let queue: DispatchQueue
    
    /// A semaphore for limiting the number of concurrent tasks.
    private let semaphore: DispatchSemaphore
    
    /**
     Initializes an instance of `NetworkQueue` with a maximum number of concurrent tasks.
     - Parameters:
        - maxConcurrentTasks: The maximum number of concurrent tasks to allow on the network queue.
     */
    init(maxConcurrentTasks: Int) {
        queue = DispatchQueue(label: "com.yourapp.networkqueue", attributes: .concurrent)
        semaphore = DispatchSemaphore(value: maxConcurrentTasks)
    }
    
    /**
     Asynchronously executes a given block of code on the network queue. The block is only executed if there is available space on the queue, otherwise it is blocked until a space becomes available.
     - Parameters:
        - block: The block of code to execute asynchronously on the network queue.
     */
    func async(_ block: @escaping () -> Void) {
        semaphore.wait()
        queue.async {
            block()
            self.semaphore.signal()
        }
    }
}
