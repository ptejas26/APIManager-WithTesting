//
//  APIManagerTests.swift
//  APIManagerTests
//
//  Created by Apple on 14/01/23.
//

import XCTest
@testable import APIManager

class MyNetworkEngine: NetworkEngine {
    
    func performRequest(url: URL, completionHandler: @escaping Handler) {
        do {
            let data = try Data(contentsOf: url)
            completionHandler(data, nil, nil)
        } catch {
            print(error.localizedDescription)
            completionHandler(nil, nil, error)
        }
    }
}

class APIManagerTests: XCTestCase {
    let networkEngine = MyNetworkEngine()
    
    func testDataLoaderImplementation() {
        
        let expectation = expectation(description: "make call to the mock test api")
        
        guard let url = Bundle.main.url(forResource: "Some", withExtension: "json") else {
            return
        }
        
        networkEngine.performRequest(url: url) { data, urlResponse, error in
            expectation.fulfill()
        }
        
    }
    
    func testLoadingData() {
        class NetworkEngineMock: NetworkEngine {
            typealias Handler = NetworkEngine.Handler
            
            var requestedURL: URL?
            
            func performRequest(url: URL, completionHandler: @escaping Handler) {
                requestedURL = url
                
                let data = "Hello world".data(using: .utf8)
                completionHandler(data, nil, nil)
            }
        }
        
        let engine = NetworkEngineMock()
        let loader = DataLoader(networkEngine: engine)
        
        var result: DataLoader.Result?
        let url = URL(string: "my/API")!
        loader.load(from: url) { result = $0 }
        
        XCTAssertEqual(engine.requestedURL, url)
        let successData = "Hello world".data(using: .utf8)!
        
        if case let .success(successData) = result {
            XCTAssertTrue(true)
        }
    }
}
