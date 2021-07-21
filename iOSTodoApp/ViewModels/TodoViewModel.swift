//
//  TodoViewModel.swift
//  iOSTodoApp
//
//  Created by Mounika Madishetti on 20/07/21.
//

import Foundation
protocol TodoProtocol {
    func addItem(todoItem: TodoItem)
    func updateItem(todoItem: TodoItem)
    func deleteItem(todoItem: TodoItem)
}
protocol UpdateTableView: class {
    func onAdd(todoItem: TodoItem)
    func onDelete(todoItem: TodoItem)
    func onUpdate(todoItem: TodoItem)
    func setup(todoItem: TodoItem)
}
class TodoViewModel: TodoProtocol {
    var database: TodoDB
    weak var delegate: UpdateTableView?
    var todoItems: [TodoItem] = [TodoItem]()
    func addItem(todoItem: TodoItem) {
        let added = database.add(usingTodoItem: todoItem)
        if added {
            DispatchQueue.main.async {
                self.delegate?.onAdd(todoItem: todoItem)
            }
        }
    }
    
    func updateItem(todoItem: TodoItem) {
        database.update(usingTodoItem: todoItem)
        DispatchQueue.main.async {
            self.delegate?.onUpdate(todoItem: todoItem)
        }
    }
    
    func deleteItem(todoItem: TodoItem) {
        database.delete(usingId: todoItem.id)
        DispatchQueue.main.async {
            self.delegate?.onDelete(todoItem: todoItem)
        }
    }
    func changeState(todoItem: TodoItem) {
        database.update(usingTodoItem: todoItem)
    }
    
    init(database: TodoDB = FirestoreDatabase.shared) {
        self.database = database
        setup(database: database)
    }
    
}
extension TodoViewModel {
    func setup(database: TodoDB) -> Void {
        database.subscribe { (todoItem) in
            print("todo item \(todoItem.name)")
            DispatchQueue.main.async {
                self.delegate?.setup(todoItem: todoItem)
            }
        }
    }
}
