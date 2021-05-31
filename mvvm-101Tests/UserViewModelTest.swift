//
//  UserViewModelTest.swift
//  mvvm-101Tests
//
//  Created by FunnyDev on 28/5/2564 BE.
//

import XCTest
import Combine
@testable import mvvm_101
class UserViewModelTest: XCTestCase {
    var apiManager: StubApiManager!
    var viewModel: UserViewModel!
    
    override func setUp() {
        apiManager = StubApiManager()
        viewModel = UserViewModel(apiManager: apiManager!, endpoint: .test)
    }
    
    override func tearDown() {
        apiManager = nil
        viewModel = nil
    }
    
    func testFetchUsersIsSuccess(){
        let expectation = XCTestExpectation(description: "test fetch users is success")
        var cancellable: AnyCancellable? = nil
        
        cancellable = viewModel.usersSubject.sink { completion in
            expectation.fulfill()
        } receiveValue: { users in
            XCTAssertEqual(1, users.count)
            XCTAssertEqual(1, users[0].id)
            XCTAssertEqual("Hello World", users[0].name)
            expectation.fulfill()
        }
        
        viewModel.fetchUsers()
        XCTAssertEqual(1, apiManager.numberOfCalled)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUsersIsFailed() {
        let expectation = XCTestExpectation(description: "test fetch users is failed")
        var cancellable: AnyCancellable? = nil
        
        cancellable = viewModel.usersSubject.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                let nrErr = error as NSError
                XCTAssertEqual(nrErr.code, NSURLErrorCannotConnectToHost)
            case .finished:
                break
            }
            expectation.fulfill()
        }, receiveValue: { users in
            expectation.fulfill()
        })
        
        
        apiManager.isError.toggle()
        viewModel.fetchUsers()
        XCTAssertEqual(1, apiManager.numberOfCalled)
        XCTAssertEqual(true, apiManager.isError)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

extension UserViewModelTest {
    class StubApiManager: APIManager {
        var numberOfCalled = 0
        var isError = false
        override func fetchItems<T>(url: URL, completion: @escaping (Result<[T], Error>) -> Void) where T : Decodable {
            
            if !isError {
                let users = [
                    User(id: 1, name: "Hello World")
                ]
                
                completion(.success(users as! [T]))
            }else {
                completion(.failure(NSError(domain: "NSURLErrorDomain", code: -1004, userInfo: nil)))
            }
            numberOfCalled += 1
        }
    }
}
