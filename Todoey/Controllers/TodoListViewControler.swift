//
//  ViewController.swift
//  Todoey
//
//  Created by Long Nguyen on 12/11/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewControler: SwipeViewController {
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory :  Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK - tableView data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = todoItems?[indexPath.row]
        cell.textLabel?.text = item?.title ?? "No item added"
        cell.accessoryType = item?.done ?? false ? .checkmark : .none
        if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    
    //MARK - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error while updating item \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK - add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "hihi", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when user click
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let addedItem = Item()
                        addedItem.title = textField.text!
                        addedItem.done = false
                        addedItem.dateCreated = Date()
                        addedItem.color = UIColor.randomFlat.hexValue()
                        currentCategory.items.append(addedItem)
                    }
                } catch {
                    print("Error while adding new item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(item : Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("error while saving items=\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
    
    func deleteCategory(item : Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("error =\(error)")
        }
        //self.tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            self.deleteCategory(item: itemForDeletion)
        }
    }
}

//MARK -  search bar method
extension TodoListViewControler : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
        }
    }
}

