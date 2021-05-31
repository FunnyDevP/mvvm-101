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
    let apiURL = URL(string: "http://localhost:8080")
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        let session = URLSession(configuration: config)
        
        apiManager = APIManager(session: session)

    }
    
    override  func tearDown() {
        apiManager = nil
    }
    
    func testGetUsers_GetUsersSuccess(){
        let expectation = XCTestExpectation(description: "get users success")
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
                XCTAssertEqual(users.count, 2)
                
                XCTAssertEqual(users[0].id, 1)
                XCTAssertEqual(users[0].name, "Luck Graham")
                
                XCTAssertEqual(users[1].id, 2)
                XCTAssertEqual(users[1].name, "Ervin Error")
                expectation.fulfill()
            case .failure(_):
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetComments_GetCommentSuccess() {
        let expectation = XCTestExpectation(description: "get comment success")
        let jsonString = #"""
            [
                {
                  "userId": 1,
                  "id": 1,
                  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
                  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
                },
                {
                  "userId": 1,
                  "id": 2,
                  "title": "qui est esse",
                  "body": "est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla"
                }
            ]
            """#
        
        let data = jsonString.data(using: .utf8)
        URLProtocolMock.testURLS[apiURL] = data
        URLProtocolMock.response = HTTPURLResponse(url: apiURL!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        apiManager.fetchItems(url: apiURL!) { (resultCompletion: Result<[Comment], Error>) in
            switch resultCompletion {
            case .success(let comments):
                XCTAssertEqual(2, comments.count)
                
                XCTAssertEqual(1, comments[0].userId)
                XCTAssertEqual(1, comments[0].id)
                XCTAssertEqual("sunt aut facere repellat provident occaecati excepturi optio reprehenderit", comments[0].title)
                XCTAssertEqual("quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto", comments[0].body)
                
                XCTAssertEqual(1, comments[1].userId)
                XCTAssertEqual(2, comments[1].id)
                XCTAssertEqual("qui est esse", comments[1].title)
                XCTAssertEqual("est rerum tempore vitae\nsequi sint nihil reprehenderit dolor beatae ea dolores neque\nfugiat blanditiis voluptate porro vel nihil molestiae ut reiciendis\nqui aperiam non debitis possimus qui neque nisi nulla", comments[1].body)
                expectation.fulfill()
            case .failure(_):
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkFailure(){
        let expectation = XCTestExpectation(description: "network failure")
        URLProtocolMock.error = NSError(domain: "NSURLErrorDomain", code: -1004, userInfo: nil)
        
        apiManager.fetchItems(url: apiURL!) { (resultCompletion: Result<[User], Error>) in
            switch resultCompletion {
            case .failure(let error):
                let nrErr = error as NSError
                XCTAssertEqual(nrErr.code, NSURLErrorCannotConnectToHost)
                expectation.fulfill()
            case .success(_):
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
