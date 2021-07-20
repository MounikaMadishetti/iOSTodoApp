//
//  TodoItem.swift
//  iOSTodoApp
//
//  Created by Mounika Madishetti on 20/07/21.
//
import Foundation
struct TodoItem: Codable {
    let id: String
    var name: String
    var isCompleted: Bool
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isCompleted
    }
}
