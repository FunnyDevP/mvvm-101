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
    
    func testsuccess(){
        let exectation = XCTestExpectation(description: "test user view model")
        var sub: AnyCancellable? = nil
        
        sub = viewModel.usersSubject.sink { completion in
            exectation.fulfill()
        } receiveValue: { users in
            XCTAssertEqual(1, users.count)
            XCTAssertEqual(1, users[0].id)
            XCTAssertEqual("Hello World", users[0].name)
            exectation.fulfill()
        }
    
        viewModel.fetchUsers()
        XCTAssertEqual(1, apiManager.numberOfCalled)
        
        wait(for: [exectation], timeout: 1.0)
    }
}
    
    extension UserViewModelTest {
        class StubApiManager: APIManager {
            var numberOfCalled = 0
            override func fetchItems<T>(url: URL, completion: @escaping (Result<[T], Error>) -> Void) where T : Decodable {
                let users = [
                    User(id: 1, name: "Hello World")
                ]
                numberOfCalled += 1
                completion(.success(users as! [T]))
            }
        }
    }
