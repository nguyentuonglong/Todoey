//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Long Nguyen on 1/24/19.
//  Copyright © 2019 Long Nguyen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeViewController {

    let realm = try! Realm()
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        let colorHex = FlatSkyBlue().hexValue()
        if let navBarColor = UIColor(hexString: colorHex) {
            navBar.barTintColor = navBarColor
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
        }
    }
    
    //MARK - tableView data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = categoryArray?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "No category added"
        if let colorAsString = item?.color {
            let color = UIColor(hexString: colorAsString)
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        }
        return cell
    }
    
    //MARK - tableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination as! TodoListViewControler
        if let indexPath = tableView.indexPathForSelectedRow {
            desVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK - add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            //What will happen when user click
            let addedItem = Category()
            addedItem.name = textField.text!
            addedItem.color = UIColor.randomFlat.hexValue()
            self.save(category: addedItem)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error =\(error)")
        }
        self.tableView.reloadData()
    }
    
    func deleteCategory(category : Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("error =\(error)")
        }
        //self.tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            self.deleteCategory(category: categoryForDeletion)
        }
    }
    
    func loadCategory() {
        categoryArray = realm.objects(Category.self)
        self.tableView.reloadData()
    }
}


