//
//  DataServiceTests.swift
//  FlickrImageSearchTests
//
//  Created by VJ on 24/12/18.
//  Copyright © 2018 Uber. All rights reserved.
//

import XCTest
@testable import FlickrImageSearch

class DataServiceTests: XCTestCase {

    var dataService: DataService!
    var session = MockURLSession()
    
    override func setUp() {
        dataService = DataService(session: session)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetURLSame() {
        
        guard let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=test&page=1") else {
            fatalError("URL can't be empty")
        }
        
        let query = "test"
        
        dataService.getPhotos(query, page: 1) { (result) in
            
        }
        
        assert(session.url == url)
    }
    
    func testResumeCalled() {
        let dataTask = MockURLSessionDataTask()
        session.dataTask = dataTask
        
        dataService.getPhotos("test", page: 1) { (result) in
            
        }
        
        assert(dataTask.resumeCalled)
    }
}

class MockURLSession: URLSessionProtocol {
    var dataTask = MockURLSessionDataTask()
    private (set) var url: URL!
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        self.url = url
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        completionHandler(Data(), urlResponse, nil)
        return dataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeCalled = false
    
    open func resume() {
        resumeCalled = true
    }
}
