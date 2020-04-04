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
    
    convenience init(z: Int) {
        self.init(x: z, y:z)
    }
}

class NamedPoint: Point {
    let label: String?
    
    init(x: Int, y: Int, label: String?) {
        self.label = label
        super.init(x: x, y: y)
    }
    
    init(point: Point, label: String?) {
        self.label = label
        super.init(x: point.x, y: point.y)
    }
    
    override init(x: Int, y: Int) {
        self.label = nil
        
        super.init(x: x, y: y)
        self.x = 2
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


// MARK: - https://theswiftdev.com/2019/08/25/swift-init-patterns/
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
        
        print("p1: \(p1) \np2: \(p2) \np3: \(p3)")
        
        let numberedP1 = NamedPoint(x: 1, y: 1, label: "first")
        let numberedP2 = NamedPoint(point: Point(x: 1, y: 1), label: "second")
        print("numberedP1: \(numberedP1) \nnumberedP2: \(numberedP2)")
    }
    
    
    func testInitializer() {
        let deviceSetting1 = DeviceSetting()
        XCTAssertNotNil(deviceSetting1)
        
        let deviceSetting2 = DeviceSetting(speaker: "", international: "", pin: "", tutorialTime: "")
        XCTAssertNotNil(deviceSetting2)
        XCTAssert(deviceSetting1.tutorialTime == nil)
        
        //let dev = DeviceSetting(speaker: <#T##String#>, international: <#T##String#>, access: <#T##String#>, pin: <#T##String?#>, tutorialTime: <#T##String?#>)
        
        //let aaa: String = deviceSetting1.pin  //Don't get compile error, but will get runtime error
    }
}



// MARK: - initializer test
struct DeviceSetting {
    var speaker: String = "YES"
    var international: String = "NO"
    
    let access: String = "AUTO" //Both var and let won't get comiple error, but let cannot be changed in initilizer, so Memberwise initializer won't include it
    var pin: String!
    var tutorialTime: String?
    
    var isSpeakerphoneOn: Bool {
        speaker.uppercased() == "YES"
    }
    
    var useInternational: Bool {
        return international.uppercased() == "YES"
    }
}
