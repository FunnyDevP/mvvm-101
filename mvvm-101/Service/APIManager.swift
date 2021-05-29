//
//  APIManager.swift
//  mvvm-101
//
//  Created by FunnyDev on 24/5/2564 BE.
//

import Foundation
import Combine

class APIManager {
    var session: URLSession
    private var subscribers = Set<AnyCancellable>()
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchItems<T: Decodable>(url: URL, completion: @escaping (Result<[T],Error>) -> Void) {
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET"
        
        self.session.dataTaskPublisher(for: urlReq)
            .map{$0.data}
            .decode(type: [T].self, decoder: JSONDecoder())
            .sink { resultCompletion in
                switch resultCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished: break
                }
            } receiveValue: { items in
                
                completion(.success(items))
            }.store(in: &subscribers)
        
        
    }
}



enum Endpoint {
    case users
    case test
    var urlString: String {
        switch self {
        case .users:
            return "https://jsonplaceholder.typicode.com/users"
        case .test:
            return "http://localhost:8080"
        }
    }
}
