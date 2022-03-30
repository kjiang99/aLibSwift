//
//  ClassTests.swift
//  aLibSwiftTests
//
//  Created by Haojun Jiang on 9/14/19.
//  Copyright © 2019 Haojun Jiang. All rights reserved.
//

import XCTest

// MARK: - struct test
struct DeviceSetting {
    var speaker: String = "YES"
    var international: String = "NO"
    
    let access: String = "AUTO"
    var pin: String!
    var tutorialTime: String?
    
    let useless: String? = nil  //let needs to set nil
    var useless2: String? //var do not need to set nil
    
    var isSpeakerphoneOn: Bool {
        speaker.uppercased() == "YES"
    }
    
    var useInternational: Bool {
        return international.uppercased() == "YES"
    }
}


struct PointStruct {
    var x: Int
    var y: Int
    let label: String? = nil  //let needs to set nil
    var key: String? //var do not need to set nil
}


class StructTests: XCTestCase {
    func testStruct() {
        let deviceSetting1 = DeviceSetting()
        XCTAssertNotNil(deviceSetting1)
        
        let deviceSetting2 = DeviceSetting(speaker: "", international: "", pin: "", tutorialTime: "")
        XCTAssertNotNil(deviceSetting2)
        XCTAssert(deviceSetting1.tutorialTime == nil)
        
        //let dev = DeviceSetting(speaker: <#T##String#>, international: <#T##String#>, access: <#T##String#>, pin: <#T##String?#>, tutorialTime: <#T##String?#>)
        
        //let aaa: String = deviceSetting1.pin  //Don't get compile error, but will get runtime error
    }
    
    
    func testPointStruct() {
        let ps1 = PointStruct(x: 0, y: 0)
        var ps2 = ps1
        ps2.x = 42
        ps2.y = 3
        print("ps1: \(ps1) \nps2: \(ps2)")
    }
}


class Point {
    var x: Int
    var y: Int
    var useless: Int?  //var do not need to set nil

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
        //Cannot assign x before super init like self.x = 2
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
    func testClass() {
        let p1 = Point(x: 0, y: 0)
        let p2 = p1
        p2.x = 42
        p2.y = 3
        
        let p3 = p1.copy() as! Point
        p3.x = 100
        p3.y = 101
        let p4 = Point(z: 3) //convenience init
        print("p1: \(p1) \np2: \(p2) \np3: \(p3) \np4: \(p4)")
        
        let namedP1 = NamedPoint(x: 1, y: 2, label: "first")
        let namedP2 = NamedPoint(point: Point(x: 3, y: 4), label: "second")
        let namedP3 = NamedPoint(x: 200, y:201) //override init
        print("namedP1: \(namedP1) \nnamedP2: \(namedP2) \nnamedP3: \(namedP3)")
    }
}




/********************************************************************
 Error Handling Enum
 ********************************************************************/
enum ServerError: Error {
    case noConnection
    case serverNotFound
    case authenticationRefused
}


func checkStatus (serverNumber: Int) throws -> String {
    switch serverNumber {
    case 1:
        print ("You have no connection.")
        throw ServerError.noConnection
    case 2:
        print ("Authentication failed.")
        throw ServerError.authenticationRefused
    case 3:
        print ("Server 3 is up and running")
    default:
        print ("Cannot find the server")
        throw ServerError.serverNotFound
    }
    return "Sccuess!"
}




class ClassTests2: XCTestCase {
    func testEnum() {
        do {
            let result = try checkStatus(serverNumber: 2)
            print(result)
        } catch let error {
            print ("The problem is: \(error)")
        }

        if let result2 = try? checkStatus(serverNumber: 3) {
            print (result2)
        }
    }
}
