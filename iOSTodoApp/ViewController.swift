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
    var completed = "Completed"
    
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
    func updateTodoItem(todoItem: TodoItem, row: Int) {
        let ac = UIAlertController(title: "Update Task", message: "enter your task", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.text = ""
            
        }
        let action = UIAlertAction(title: "Update Task", style: .default, handler: { [weak ac] (action) -> Void in
            let textField = (ac?.textFields![0])! as UITextField
            self.todoItems[row].name = textField.text ?? ""
            self.tableView.reloadData()
        })
        
        ac.addAction(action)
        self.present(ac, animated: true) {
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.todoViewModel?.updateItem(todoItem: todoItem)
            }
            
        }
    }
    func deleteTodoItem(todoItem: TodoItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.todoViewModel?.deleteItem(todoItem: todoItem)
        }
    }
    func crossText(todoItem: TodoItem) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.todoViewModel?.changeState(todoItem: todoItem)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: todoItems[indexPath.row].name)
        if todoItems[indexPath.row].isCompleted {
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
            //attributedString.addAttributes(NSAttributedString.Key.foregroundColor, value: .green , range: NSMakeRange(0, attributedString.length))
            cell.textLabel?.attributedText = attributedString
        } else {
            cell.textLabel?.attributedText = attributedString
        }
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action1 = UIContextualAction(style: .normal, title: "Update") { [weak self] (action, view, completionHandler) in
            self?.updateTodoItem(todoItem: (self?.todoItems[indexPath.row])!, row: indexPath.row)
            completionHandler(true)
            
        }
        let action2 = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteTodoItem(todoItem: (self?.todoItems[indexPath.row])!)
            completionHandler(true)
            
        }
        if self.todoItems[indexPath.row].isCompleted == true {
            completed = "Not Completed"
        } else {
            completed = "Completed"
        }
        let action3 = UIContextualAction(style: .normal, title: self.completed) { [weak self] (action, view, completionHandler) in
            if self?.todoItems[indexPath.row].isCompleted == true {
                self?.todoItems[indexPath.row].isCompleted = false
            } else {
                self?.todoItems[indexPath.row].isCompleted = true
            }
            self?.crossText(todoItem: (self?.todoItems[indexPath.row])!)
            completionHandler(true)
            
        }
        action1.backgroundColor = .green
        action2.backgroundColor = .red
        action3.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [action1, action2, action3])
    }
    
    
}
extension ViewController: UpdateTableView {
    func onAdd(todoItem: TodoItem) {
        todoItems.append(todoItem)
        self.addItemTextField.text = ""
        tableView.reloadData()
    }
    func onDelete(todoItem: TodoItem) {
        var i = 0
        for item in todoItems {
            if item.name == todoItem.name {
                break
               
            }
            i = i + 1
        }
        todoItems.remove(at: i)
        tableView.reloadData()
    }
    func onUpdate(todoItem: TodoItem) {
       let item =  todoItems.filter( {
            $0.id == todoItem.id
        })
       // tableView.reloadData()
    }
    
    
}

