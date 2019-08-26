//
//  IOTests.swift
//  aLibSwiftTests
//
//  Created by Haojun Jiang on 8/18/19.
//  Copyright © 2019 Haojun Jiang. All rights reserved.
//

import XCTest
import UIKit
@testable import aLibSwift

extension FileManager {
    static var documentDirectoryURL : URL {
        //FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

class IOTests: XCTestCase {
    func testFileManager() {
        //Important: May need to create Documents folder manually
        let documentPath1 = FileManager.documentDirectoryURL.path
        let documentPath2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path
        assert(documentPath1 == documentPath2)
        
        let fm1 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fm2 = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        assert(fm1 == fm2)
        
        let fileUrl1 = FileManager.documentDirectoryURL.appendingPathComponent("aaa.bbb").appendingPathExtension("txt")
        let fileUrl1Path = fileUrl1.path
        let fileUrl1Name = fileUrl1.lastPathComponent
        
        let fileUrl2 = URL(fileURLWithPath: "aaa.bbb", relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("txt")
        let fileUrl2Path = fileUrl2.path
        let fileUrl2Name = fileUrl2.lastPathComponent
        assert(fileUrl1 != fileUrl2)
        assert(fileUrl1Path == fileUrl2Path)
        assert(fileUrl1Name == fileUrl2Name)
    }
    
    
    func testReadWrite(){

        let mysteryBytes: [UInt8] = [
            240,          159,          152,          184,
            240,          159,          152,          185,
            0b1111_0000,  0b1001_1111,  0b1001_1000,  186,
            0xF0,         0x9F,         0x98,         187
        ]
        
        let mysteryDataUrl = FileManager.documentDirectoryURL.appendingPathComponent("aaa.bbb").appendingPathExtension("txt")
        let mysteryData = Data(mysteryBytes)
        try! mysteryData.write(to: mysteryDataUrl)
        
        let savedMysteryData = try! Data(contentsOf: mysteryDataUrl)
        let savedMysteryBytes = Array(savedMysteryData)
        assert(savedMysteryData == mysteryData)
        assert(savedMysteryBytes == mysteryBytes)
        
        let string = String(data: savedMysteryData, encoding: .utf8)!
        let stringUrl = FileManager.documentDirectoryURL.appendingPathComponent("aaa2.bbb").appendingPathExtension("txt")
        
        try! string.write(to: stringUrl, atomically: true, encoding: .utf8)
        let stringResult = try! String(contentsOf: stringUrl)
        assert(string == stringResult)
    }
    
    
    func testImageJson() {
        //https://stackoverflow.com/questions/19151420/load-files-in-xcode-unit-tests/31651573
        let bundle = Bundle(for: type(of: self))
        
        let images = try! [Image](bundle: bundle, fileName: "images")
        let imagesUI = images.map {UIImage(data: $0.pngData)}
        let imageNames = images.map {$0.name}
        assert(imagesUI.count == 10 && imageNames.count == 10)
        
        let image = try! Image(bundle: bundle, fileName: "image")
        assert(image.name == "frog" && image.imageSize > 0)
    }
    
    
    func testItunesJson() {
        let bundle = Bundle(for: type(of: self))
        let urlBeetles =  bundle.url(forResource: "itunesBeatles", withExtension: "json")!
        let dataBeetles = try! Data(contentsOf: urlBeetles)
        
        let listBeetles = try! JSONDecoder().decode(TrackList.self, from: dataBeetles)
        assert(listBeetles.results.count == 50)
        
        do {
            guard let urlMozart =  bundle.url(forResource: "itunesMozartBadData", withExtension: "json") else { return }
            let dataMozart = try Data(contentsOf: urlMozart)
            let _ = try JSONDecoder().decode(TrackList.self, from: dataMozart)
        } catch  {
            print ("Error when decode Mozart json file: \(error)")
        }
    }
}


struct Track: Decodable {
    let trackName: String
    let artistName: String
    let previewUrl: String
    var url: URL {
        return URL(string: previewUrl)!
    }
}

struct TrackList: Decodable {
    let results: [Track]
}


struct Image: Decodable {
    enum Kind: String, Decodable {
        case scene
        case sticker
    }
    
    enum DecodingError: Error {
        case missingFile
    }
    
    let name: String
    let kind: Kind
    let pngData: Data
    var imageSize: Int {
        return Array(pngData).count
//        get {
//            return Array(pngData).count
//        }
    }
    
    init(bundle: Bundle, fileName: String) throws {
        guard let url =  bundle.url(forResource: fileName, withExtension: "json") else {
            throw Image.DecodingError.missingFile
        }

        let decoder = JSONDecoder()
        let data = try Data(contentsOf: url)
        self = try decoder.decode(Image.self, from: data)
    }
}


extension Array where Element == Image {
    init(bundle: Bundle, fileName: String) throws {
        guard let url =  bundle.url(forResource: fileName, withExtension: "json") else {
            throw Image.DecodingError.missingFile
        }
        
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: url)
        self = try decoder.decode([Image].self, from: data)
    }
}
