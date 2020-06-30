//
//  ClassTests2.swift
//  aLibSwiftTests
//
//  Created by Haojun Jiang on 4/3/20.
//  Copyright © 2020 Haojun Jiang. All rights reserved.
//

import Foundation
import XCTest


class AsyncTests: XCTestCase {
    var currentValue: Int?
    
    func addAsync(_ a: Int, _ b: Int) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.0,
            execute: {
                self.currentValue = a + b
        })
    }
    
    func addAsync2(_ a: Int, _ b: Int, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 1.0,
            execute: {
                self.currentValue = a + b
                completion()
        })
    }
    
    
    func testAddAsync() {
        addAsync(3, 4)
        XCTAssertEqual(self.currentValue, nil)
    }
    
    
    func testAddAsync2() {
        let expect = expectation(description: "completion block was called")
        addAsync2(3, 4) {
            expect.fulfill()
            XCTAssertEqual(self.currentValue, 7)
        }
        
        wait(for: [expect], timeout: 2.0)
    }
}



