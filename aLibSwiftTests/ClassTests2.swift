//
//  ClassTests2.swift
//  aLibSwiftTests
//
//  Created by Haojun Jiang on 4/3/20.
//  Copyright © 2020 Haojun Jiang. All rights reserved.
//

import Foundation
import XCTest


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
