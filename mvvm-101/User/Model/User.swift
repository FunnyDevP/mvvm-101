//
//  User.swift
//  mvvm-101
//
//  Created by FunnyDev on 24/5/2564 BE.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
}

struct Comment: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
