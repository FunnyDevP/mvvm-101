//
//  URLProtocolMock.swift
//  mvvm-101Tests
//
//  Created by FunnyDev on 26/5/2564 BE.
//

import Foundation

class URLProtocolMock: URLProtocol {
    static var testURLS = [URL?: Data]()
    static var response: URLResponse?
    static var error: Error?
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    
    override func startLoading() {
        print("start loading...")
        if let url = request.url {
            if let data = URLProtocolMock.testURLS[url] {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        
        if let response = URLProtocolMock.response {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = URLProtocolMock.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        print("stop loading....")
    }
}
