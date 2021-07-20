//
//  TodoDB.swift
//  iOSTodoApp
//
//  Created by Mounika Madishetti on 20/07/21.
//

import Foundation
protocol TodoDB {
    func add(usingTodoItem todoItem: TodoItem) -> Bool
    func update(usingTodoItem todoItem: TodoItem) -> Void
    func delete(usingId id: String) -> Void
    
}
