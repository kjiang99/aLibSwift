//
//  MultiThreadSingletonTests.swift
//  aLibSwiftTests
//
//  Created by Haojun Jiang on 9/15/19.
//  Copyright © 2019 Haojun Jiang. All rights reserved.
//

import XCTest

final public class AppSettings {
    private var settings: [String: Any] = [:]
    
    public static let shared = AppSettings()
    
    //private let serialQueue = DispatchQueue(label: "serialQueue")
    private let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    
    private init() {}
    
    public func set(_ value: Any, forKey key: String) {
        //serialQueue.sync {
        concurrentQueue.async( flags: .barrier ) {
            self.settings[key] = value
        }
    }
    
    public func object(forKey key: String) -> Any? {
        var result: Any?
        //serialQueue.sync {
        concurrentQueue.sync {
            result = settings[key]
        }
        return result
    }
    
    public func reset() {
        settings.removeAll()
    }
}

class MultiThreadTests: XCTestCase {
    
    func testSingletonConcurrentQueue() {
        // Add key-value pairs to AppSettings
        let count = 100
        for index in 0..<count {
            AppSettings.shared.set(index, forKey: String(index))
        }
        
        // Retrieve the values concurrently
        // The dispatch queue executes the submitted blocks in parallel
        // and waits for all iterations to complete before returning
        DispatchQueue.concurrentPerform(iterations: count) { (index) in
            if let n = AppSettings.shared.object(forKey: String(index)) as? Int {
                print(n)
            }
        }
        
        // Reset the singleton
        AppSettings.shared.reset()
        
        // Re-add the key-value pairs concurrently
        DispatchQueue.concurrentPerform(iterations: count) { (index) in
            print("Iteration index \(index)")
            AppSettings.shared.set(index, forKey: String(index))
        }
    }
}
