//
//  NetworkTests.swift
//  aLibSwiftTests
//
//  Created by Haojun Jiang on 8/19/19.
//  Copyright © 2019 Haojun Jiang. All rights reserved.
//

import XCTest

class NetworkTests: XCTestCase {
    
    func testSessionConfiguration() {
        let sharedSession = URLSession.shared
        let allowsCellularAccess1 = sharedSession.configuration.allowsCellularAccess
        assert(allowsCellularAccess1)
        sharedSession.configuration.allowsCellularAccess = false
        let allowsCellularAccess2 = sharedSession.configuration.allowsCellularAccess
        assert(allowsCellularAccess2)
        
        let myDefaultConfiguration = URLSessionConfiguration.default
        myDefaultConfiguration.allowsCellularAccess = false //default is true
        let myDefaultSession = URLSession(configuration: myDefaultConfiguration)
        XCTAssert(myDefaultSession.configuration.allowsCellularAccess == false)
//        let eConfig = URLSessionConfiguration.ephemeral
//        let bConfig = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.sessions")
        
        
        //Synchronous way to get an image
        let imageURL = URL(string: "http://vote1.azurewebsites.net/images/Return.jpg")!
        let imageData = try! Data(contentsOf: imageURL)
        let uiImage = UIImage(data: imageData)
        assert(uiImage != nil)
        
        
        //let urlCookie = URL(string: "https://dorm2.azurewebsites.net")!
        //let urlCookie = URL(string: "https://www.raywenderlich.com")!
        let urlCookie = URL(string: "http://www.amazon.com")!
        let requestCookie = URLRequest(url: urlCookie)
        
        let expect = expectation(description: "expect")
        
        sharedSession.dataTask(with: requestCookie) { (data, response, error) in
            print ("\nCookies are:")
            guard let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode) else { return }
            
            if let fields = httpResponse.allHeaderFields as? [String : String] {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: urlCookie)
                for cookie in cookies {
                    print("cookie name:\(cookie.name)")
                    print("cookie value:\(cookie.value)")
                }
                print ("\n")
            }
            
            if let cookieJar = HTTPCookieStorage.shared.cookies {
                print ("\nCookieStorage cookies are:")
                for cookie in cookieJar {
                    print("cookie name: \(cookie.name)")
                    print("cookie value: \(cookie.value)")
                }
            }
            
            expect.fulfill()
        }.resume()
        
        wait(for: [expect], timeout: 10.0)
    }
    
    
    // MARK: - testSessionDataTaskPost
    struct Student : Encodable {
        let id: Int
        let acadSessionId: Int
        let assignedDormRoomName : String
        let isBoardingStudent : Bool
    }
    
    func testSessionDataTaskPost() {
//        let student = Student(id: 1, acadSessionId: 1, assignedDormRoomName: "101", isBoardingStudent: true)
//        let studentJsonData = try! JSONEncoder().encode(student)
        
        let student = "{'id': '1','acadSessionId' :'1','assignedDormRoomName' : '101','isBoardingStudent' : 'true'}"
        let studentJsonData = student.data(using: .utf8)
        
        let assignStudentEndpointUrl = URL(string: "https://dorm2.azurewebsites.net/api/Dorm/AssignStudentDormRoom/")!
        var request = URLRequest(url: assignStudentEndpointUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = studentJsonData
        
        let expect = expectation(description: "expect")
        
        let session = URLSession(configuration: .default)
        let taskPost = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print("\(error)\n")
                }
                return
            }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("\ndataString:\n\(dataString)\n")
            }
            
            expect.fulfill()
        }
        
        taskPost.resume()
        wait(for: [expect], timeout: 10.0)
    }
    
    
    // MARK: - testTokenAuthentication
    struct User: Encodable {
        let username: String
    }
    
    struct Auth : Decodable {
        let token : String
    }
    
    func testTokenAuthentication() {
        let expect = expectation(description: "expect")
        
        let user = User(username: "PowerUserB")
        let userJsonData = try! JSONEncoder().encode(user)
        
        let loginEndpointUrl = URL(string: "https://dorm2.azurewebsites.net/api/Security/Authenticate/")!
        var loginRequest = URLRequest(url: loginEndpointUrl)
        loginRequest.httpMethod = "POST"
        loginRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        loginRequest.httpBody = userJsonData
//        let encodedString = userJsonData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
//        loginRequest.allHTTPHeaderFields = [
//          "accept": "application/json",
//          "content-type": "application/json",
//          "authorization": "Basic \(encodedString)"
//        ]
        
        let session = URLSession(configuration: .default)
    
        let taskAuth = session.dataTask(with: loginRequest) { (data, response, error) in
            guard let data = data else { return }
            
            if let dataString = String(data: data, encoding: .utf8) {
                print("\ndataString:\n\(dataString)\n")
            }
            
            let auth = try! JSONDecoder().decode(Auth.self, from: data)

            let claimEndpointUrl = URL(string: "https://dorm2.azurewebsites.net/api/Security/GetClaims/")!
            var tokenAuthRequest = URLRequest(url: claimEndpointUrl)
            tokenAuthRequest.httpMethod = "GET"
            tokenAuthRequest.allHTTPHeaderFields = [
                "accept": "application/json",
                "content-type": "application/json",
                "authorization": "Bearer \(auth.token)"
            ]
            
            session.dataTask(with: tokenAuthRequest) { (data, response, error) in
                guard let data = data else { return }
                
                if let dataString = String(data: data, encoding: .utf8) {
                    print("\ndataString:\n\(dataString)\n")
                }
                
                expect.fulfill()
            }.resume()
            
        }
        
        taskAuth.resume()
        wait(for: [expect], timeout: 10.0)
    }
    
    

    // MARK: - testDownloadLargeFile
    func testDownloadLargeFile() {
        //let urlDownload = URL(string: "http://hccc.net/aaa.mpg")!
        let urlDownload = URL(string: "http://hccc.net/aaa.txt")!
        
        let sessionDelegate = DownloadSessionDelegate()
        let expect = expectation(description: "expect")
        sessionDelegate.expect = expect
        
        let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: OperationQueue.main)
        let taskDownload = session.downloadTask(with: urlDownload)
        taskDownload.resume()
        
        wait(for: [expect], timeout: 30.0)
    }
}


//https://medium.com/journey-of-one-thousand-apps/tracking-download-progress-with-swift-c1a13f3f8c66
class DownloadSessionDelegate: NSObject, URLSessionDownloadDelegate {
    var expect: XCTestExpectation?
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadURL: \(location)\n")

        guard let url = downloadTask.originalRequest?.url else { return }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        print("destinationURL: \(destinationURL)\n")

        try? FileManager.default.removeItem(at: destinationURL)
        try? FileManager.default.copyItem(at: location, to: destinationURL) //After delegate ends, the downloaded file automatically deleted in temp folder
        expect?.fulfill()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
        let progress = round(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100)
        print("progress: \(progress) % \n")
    }
}



//class SessionDelegate: NSObject, URLSessionDataDelegate {
//    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
//        let progress = round(Float(totalBytesSent) / Float(totalBytesExpectedToSend) * 100)
//        print("progress: \(progress) %")
//    }
//}
//
//let image = UIImage(named: "mojave-day.jpg")
//let imageData = image?.jpegData(compressionQuality: 1.0)
//let uploadURL = URL(string: "htts://dorm2.azurewebsites.net")!
//
//var request = URLRequest(url: uploadURL)
//request.httpMethod = "POST"
//
//let session = URLSession(configuration: .default, delegate: SessionDelegate(), delegateQueue: OperationQueue.main)
//let task = session.uploadTask(with: request, from: imageData) { (data, response, error) in
//    let serverResponse = String(data: data!, encoding: .utf8)
//    print(serverResponse!)
//}
//
//task.resume()
