//
//  ViewController.swift
//  iOSTodoApp
//
//  Created by Mounika Madishetti on 20/07/21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var addItemTextField: UITextField!
    var todoText: String = ""
    var todoViewModel: TodoViewModel?
    var todoItems: [TodoItem] = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoViewModel = TodoViewModel()
        todoViewModel?.delegate = self
    }

    @IBAction func addItemButtonHandler(_ sender: Any) {
        //add item to firebase firestore
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.todoViewModel?.addItem(todoItem: TodoItem(id: self?.todoText ?? "", name: self?.todoText ?? "", isCompleted: false))
        }
    }
    
}
extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        todoText = textField.text ?? ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = textField.resignFirstResponder()
        return true
    }
    
}
extension ViewController: UITableViewDelegate {
    
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todocell") else { return UITableViewCell() }
        cell.textLabel?.text = todoItems[indexPath.row].name
        return cell
    }
    
    
}
extension ViewController: UpdateTableView {
    func updateTableViewData(todoItem: TodoItem) {
        todoItems.append(todoItem)
        print(todoItems)
        tableView.reloadData()
    }
    
    
}

