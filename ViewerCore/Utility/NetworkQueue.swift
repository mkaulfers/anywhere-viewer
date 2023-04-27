//
//  NetworkQueue.swift
//  WireViewer
//
//  Created by Matthew Kaulfers on 4/26/23.
//

import Foundation

class NetworkQueue {
    private let queue: DispatchQueue
    private let semaphore: DispatchSemaphore

    init(maxConcurrentTasks: Int) {
        queue = DispatchQueue(label: "com.yourapp.networkqueue", attributes: .concurrent)
        semaphore = DispatchSemaphore(value: maxConcurrentTasks)
    }

    func async(_ block: @escaping () -> Void) {
        semaphore.wait()
        queue.async {
            block()
            self.semaphore.signal()
        }
    }
}
