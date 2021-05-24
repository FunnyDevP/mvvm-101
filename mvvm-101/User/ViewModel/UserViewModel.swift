//
//  UserViewModel.swift
//  mvvm-101
//
//  Created by FunnyDev on 24/5/2564 BE.
//

import Foundation
import Combine

class UserViewModel{
    private let apiManager: APIManager
    private let endpoint: Endpoint
    
    var usersSubject = PassthroughSubject<[User],Error>()
    
    init(apiManager: APIManager, endpoint: Endpoint) {
        self.apiManager = apiManager
        self.endpoint = endpoint
    }
    
    func fetchUsers(){
        let url = URL(string: endpoint.urlString)!
        apiManager.fetchItems(url: url) { (result: Result<[User],Error>)  in
            switch result {
            case .success(let users):
                self.usersSubject.send(users)
            case .failure(let error):
                self.usersSubject.send(completion: .failure(error))
            }
        }
    }
}
