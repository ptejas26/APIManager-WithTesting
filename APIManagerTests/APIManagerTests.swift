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
    
    
}
