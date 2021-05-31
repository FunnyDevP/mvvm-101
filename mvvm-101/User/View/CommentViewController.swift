//
//  Comments.swift
//  mvvm-101
//
//  Created by FunnyDev on 31/5/2564 BE.
//

import Foundation
import Combine

class CommentViewModel{
    private let apiManager: APIManager!
    private let endpoint: Endpoint!
    
    var commentSubject = PassthroughSubject<[Comment], Error>()
    
    init(apiManager: APIManager, endpoint: Endpoint) {
        self.apiManager = apiManager
        self.endpoint = endpoint
    }
    
    func fetchComment() {
        let url = URL(string: endpoint.urlString)!
        apiManager.fetchItems(url: url) { (resultCompletion: Result<[Comment], Error>) in
            switch resultCompletion {
            case .success(let comments):
                self.commentSubject.send(comments)
            case .failure(let error):
                self.commentSubject.send(completion: .failure(error))
            }
        }
    }
    
    
}
