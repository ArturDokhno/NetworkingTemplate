//
//  Todo.swift
//  NetworkingTemplate
//
//  Created by Артур Дохно on 24.11.2021.
//

import Foundation

// MARK: - Todo
struct Todo: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
