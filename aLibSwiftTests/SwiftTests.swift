//
//  SwiftTests.swift
//  aLibSwiftTests
//
//  Created by Haojun Jiang on 8/19/22.
//  Copyright © 2022 Haojun Jiang. All rights reserved.
//

import XCTest

class SwiftTests: XCTestCase {

    // MARK: - string test
    func testString() {
        //******* String 增删改查
        var str = "ABCDEF"
        
        XCTAssert(str.contains("BC") == true)
        XCTAssert(str.hasPrefix("AB") == true)
        XCTAssert(str.hasSuffix("EF") == true)
        
        str.insert(contentsOf: "??", at: str.index(str.startIndex, offsetBy: 3))
        XCTAssert(str == "ABC??DEF")
        
        let index1 = str.index(str.startIndex, offsetBy: 3)
        let index2 = str.index(str.startIndex, offsetBy: 4)
        let range = index1 ... index2
        str.replaceSubrange(range, with: "!!!")
        XCTAssert(str == "ABC!!!DEF")
        
        let value = str.replacingOccurrences(of: "!!!", with: "$$$")  //没有直接改原来string
        XCTAssert(value == "ABC$$$DEF")
        
        str.remove(at: str.index(str.startIndex, offsetBy: 1))
        XCTAssert(str == "AC!!!DEF")
        
        str.removeSubrange((str.index(str.startIndex, offsetBy: 2) ... str.index(str.startIndex, offsetBy: 4)))
        XCTAssert(str == "ACDEF")
        
        
        
        //******* String操作
        let lastChar = str[str.index(before: str.endIndex)]
        XCTAssert(lastChar == "F")
        
        let lastString = str[str.index(str.endIndex, offsetBy: -2) ... str.index(str.endIndex, offsetBy: -1)]
        XCTAssert(lastString == "EF")
        
        let indexE = str.firstIndex(of: "E") ?? str.endIndex
        let stringToE = str[str.startIndex...indexE]
        XCTAssert(stringToE == "ACDE")
        
        let prefix4 = str.prefix(4)
        XCTAssert(prefix4 == "ACDE")
        
        let aaa = #""he“”llo""# //打印有引号的字符串 “he“”llo"
        print (aaa)
        
        let bbb = """
    Hello

        Swift
"""
        print (bbb)
    }
    
    
    // MARK: - array test
    func testArray() {
        //******* stride
        for index in stride(from: 0, through: 10, by: 2){
            print (index)
        }
        
        
        //******* array
        var codes: [String] = []
        var codes2 = [String]()
        
        var array = [1,2,3,4]
        let a1 = array[1] //a1是Int不是Int？
        
        array.insert(11, at: 1)
        _ = array.contains(11)
        array.replaceSubrange((2...3), with: [12, 13])
        array.remove(at: 0)
        
        array.sort(by: {(s1, s2) -> Bool in
            if (s1 > s2)
            {
                return true
            }
            else {
                return false
            }
        })
        
        
      //for item in array[0...] //也可以这么用
        for index in (0..<array.count).reversed(){
            print (array[index])
        }
        
        
        //******* dictionary
        var dictionary: Dictionary<String, String> = [:]
        var dictionary2 = [String:String]()
        
        dictionary["USA"] = "DC"
        dictionary.updateValue("Beijing", forKey: "China")
        let notExist = dictionary["notExist"]
        
        for (key, value) in dictionary {
            print (key + " - " + value)
        }
    }
    
    
    // MARK: - func test
    func testFunc() {
        
        //******* pass String... is like pass array
        func test1 (name: String...) {
            print (type(of: name))
        }
        
        test1(name: "a", "b", "c")  //Array<String>
        
        
        //******* inname outname
        func test2(outname inname:String) {
            print(inname)
        }
        
        test2(outname: "hello")
        
        
        //******* assert
        func test3(param: Int) {
            if (param < 10) {
                assert(false, "Stop!")
            }
        }
        //test3(param: 3)
        
        
        //******* pass array
        let test4:([Int]) -> String = {items in
            var result = ""
            for item in items {
                result = result + String(item) + ","
            }
            return result
        }
        
        print(test4([1, 2, 3]))
        
        
        //******* inout keyword
        func test5(param: inout Int) {
            param = param * 2
            print (param)
        }
        
        var a = 10
        test5(param: &a)
        print ("传值后a = " + String(a))
        
        
        //******* 简写
        let test5 = {}
        print(type(of: test5)) // 结果： () -> ()
    }
}
