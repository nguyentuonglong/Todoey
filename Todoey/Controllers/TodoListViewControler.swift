//
//  ViewController.swift
//  Todoey
//
//  Created by Long Nguyen on 12/11/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class TodoListViewControler: UITableViewController {
    
    var itemArray = [Item]()
    let KEY_LIST = "TodoListArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem1 = Item()
        newItem1.title = "Finding Nemo"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "God of War"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Tomb Rider"
        itemArray.append(newItem3)
        
        loadItems()
    }
    
    //MARK - tableView data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    //MARK - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: false)
        self.saveItems()
    }
    
    //MARK - add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "hihi", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user click
            let addedItem = Item()
            addedItem.title = textField.text!
            self.itemArray.append(addedItem)
            self.tableView.reloadData()
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("error =\(error)")
        }
    }
    
    func loadItems() {
        if let  data = try? Data(contentsOf: dataFilePath!) {
        let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error =\(error)")
            }
        }
    }
    
    

}

