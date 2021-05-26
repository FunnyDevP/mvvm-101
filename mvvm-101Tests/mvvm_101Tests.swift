//
//  mvvm_101Tests.swift
//  mvvm-101Tests
//
//  Created by FunnyDev on 26/5/2564 BE.
//

import XCTest

@testable import mvvm_101
class mvvm_101Tests: XCTestCase {

    var apiManager: APIManager!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "http://localhost:8080")
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        let session = URLSession(configuration: config)
        
        
        expectation = expectation(description: "expectation")
        apiManager = APIManager(session: session)
        
        
    }
    
    override  func tearDown() {
        apiManager = nil
    }
    
    func testSuccessfulResponse(){
        let jsonString = """
            [
              {
                "id": 1,
                "name": "Luck Graham",
                "username": "Bret",
              },
              {
                "id": 2,
                "name": "Ervin Error",
                "username": "Antonette",
              },
            ]
            """
        
        let data = jsonString.data(using: .utf8)
        URLProtocolMock.testURLS[apiURL] = data
        URLProtocolMock.response = HTTPURLResponse(url: apiURL!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        
        apiManager.fetchItems(url: apiURL!) { (resultCompletion: Result<[User], Error>) in
            switch resultCompletion {
            case .success(let users):
             print(users)
                XCTAssertEqual(users.count, 2)
                
                XCTAssertEqual(users[0].id, 1)
                XCTAssertEqual(users[0].name, "Luck Graham")
                
                XCTAssertEqual(users[1].id, 2)
                XCTAssertEqual(users[1].name, "Ervin Error")
                self.expectation.fulfill()
            case .failure(_):
                self.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
        
       
        
    }
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    



}
