//
//  FirestoreDatabase.swift
//  iOSTodoApp
//
//  Created by Mounika Madishetti on 20/07/21.
//

import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift

class FirestoreDatabase {
    private let firebaseDb = Firestore.firestore()
    static let shared = FirestoreDatabase()
    private let todosCollection = "todos"
    private init() { }
}
extension FirestoreDatabase: TodoDB {
    
    
    func subscribe(completion: @escaping (TodoItem) -> Void) {
        firebaseDb.collection(todosCollection)
            .addSnapshotListener { (snapshot, error) in
                guard let collection = snapshot else { return }
                collection.documentChanges.forEach { (change) in
                    do {
                        if change.type == .added, let item = try change.document.data(as: TodoItem.self) {
                            completion(item)
                        }
                       
                    } catch let error {
                        print("error fetching \(error)")
                    }
                }
            }
    }
    
    func add(usingTodoItem todoItem: TodoItem) -> Bool {
        do {
           let ref = try firebaseDb.collection(todosCollection)
                .addDocument(from: todoItem)
            print("add doc succeded with id = \(ref.documentID)")
        } catch let error {
            print("add doc failed \(error)")
            return false
        }
       
        return true
    }
    
    func update(usingTodoItem todoItem: TodoItem) {
        firebaseDb.collection(todosCollection)
            .whereField("id", isEqualTo: todoItem.id)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("error updating \(error)")
                } else {
                    if let document = snapshot?.documents.first {
                        do {
                        try document.reference.setData(from: todoItem)
                        } catch let error {
                            print("error updating \(error)")
                        }
                    }
                }
            }
    }
    
    func delete(usingId id: String) {
        firebaseDb.collection(todosCollection)
            .whereField("id", isEqualTo: id)
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("error deleting \(error)")
                } else {
                    if let document = snapshot?.documents.first {
                        document.reference.delete { (error) in
                            print("error deleting \(String(describing: error))")
                            
                        }
                    }
                }
                
            }
        
    }
    
    
}
