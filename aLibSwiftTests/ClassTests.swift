//
//  ClassTests.swift
//  aLibSwiftTests
//
//  Created by Haojun Jiang on 9/14/19.
//  Copyright © 2019 Haojun Jiang. All rights reserved.
//

import XCTest

struct PointStruct {
    var x: Int
    var y: Int
}

class Point {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        return "Point (\(x), \(y))"
    }
}

extension Point: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return Point(x: self.x, y: self.y)
    }
}

class ClassTests: XCTestCase {
    func testClassStructureType() {
        let ps1 = PointStruct(x: 0, y: 0)
        var ps2 = ps1
        ps2.x = 42
        ps2.y = 3
        print("ps1: \(ps1) \nps2: \(ps2)")
        
        let p1 = Point(x: 0, y: 0)
        let p2 = p1
        p2.x = 42
        p2.y = 3
        
        let p3 = p1.copy() as! Point
        p3.x = 100
        p3.y = 101
        
        print("p1: \(p1) \np2: \(p2) \np3: \(p3) ")
    }
}
