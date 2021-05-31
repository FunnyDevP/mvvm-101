//
//  CommentViewModelTest.swift
//  mvvm-101Tests
//
//  Created by FunnyDev on 1/6/2564 BE.
//

import XCTest
import Combine

@testable import mvvm_101
class CommentViewModelTest: XCTestCase {
    var apiManager: APIManagerMock!
    var viewModel: CommentViewModel!
    
    override func setUp() {
        apiManager = APIManagerMock()
        viewModel = CommentViewModel(apiManager: apiManager, endpoint: .test)
    }
    
    override func tearDown() {
        apiManager = nil
        viewModel = nil
    }
    
    func testCommentViewModel_GetCommentSuccess() {
        let expectation = XCTestExpectation(description: "get comment success")
        var cancellable: AnyCancellable? = nil
        
        cancellable = viewModel.commentSubject.sink { _ in
            expectation.fulfill()
        } receiveValue: { comments in
            XCTAssertEqual(2, comments.count)
            
            XCTAssertEqual(1, comments[0].userId)
            XCTAssertEqual(1, comments[0].id)
            XCTAssertEqual("title 1", comments[0].title)
            XCTAssertEqual("body 1", comments[0].body)
            
            XCTAssertEqual(1, comments[1].userId)
            XCTAssertEqual(2, comments[1].id)
            XCTAssertEqual("title 2", comments[1].title)
            XCTAssertEqual("body 2", comments[1].body)
            expectation.fulfill()
        }
        
        viewModel.fetchComment()
        XCTAssertEqual(1, apiManager.numberOfCalled)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testCommentViewModel_GetCommentFailed() {
        let expectation = XCTestExpectation(description: "get comment failed")
        var cancellable: AnyCancellable? = nil
        
        cancellable = viewModel.commentSubject.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                let nrErr = error as NSError
                XCTAssertEqual(nrErr.code, NSURLErrorCannotConnectToHost)
                expectation.fulfill()
            case .finished:
                break
            }
        }, receiveValue: { _ in
            expectation.fulfill()
        })
        
        apiManager.isError.toggle()
        viewModel.fetchComment()
        XCTAssertEqual(1, apiManager.numberOfCalled)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

extension CommentViewModelTest {
    class APIManagerMock: APIManager {
        var numberOfCalled = 0
        var isError = false
        override func fetchItems<T>(url: URL, completion: @escaping (Result<[T], Error>) -> Void) where T : Decodable {
            numberOfCalled += 1
            
            if isError {
                completion(.failure(NSError(domain: "NSURLErrorDomain", code: -1004, userInfo: nil)))
            }
            let comments = [
                Comment(userId: 1, id: 1, title: "title 1", body: "body 1"),
                Comment(userId: 1, id: 2, title: "title 2", body: "body 2"),
            ]
            completion(.success(comments as! [T]))
        }
    }
}
