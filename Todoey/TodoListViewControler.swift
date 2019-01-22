//
//  ViewController.swift
//  Todoey
//
//  Created by Long Nguyen on 12/11/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class TodoListViewControler: UITableViewController {
    
    var itemArray = ["item 1","item 2", "item 3"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - tableView data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isCheked = tableView.cellForRow(at: indexPath)?.accessoryType
        let cell = tableView.cellForRow(at: indexPath)
        if isCheked == .checkmark{
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "hihi", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user click
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    

}

