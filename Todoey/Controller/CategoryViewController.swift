//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Alok Acharya on 3/1/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        
        navBar.barTintColor = UIColor(hexString: "1D9BF6")
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        guard let navBar = navigationController?.navigationBar else {
    //            fatalError("Navigation controller does not exist")
    //        }
    //
    //        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    //    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let categoryValue = categories?[indexPath.row]{
            cell.textLabel?.text = categoryValue.name
            cell.backgroundColor = UIColor(hexString: categoryValue.colorVal)
            
            guard let categeoryColor = UIColor(hexString: categoryValue.colorVal) else { fatalError() }
            
            cell.textLabel?.textColor = ContrastColorOf(categeoryColor, returnFlat: true)
        }else{
            categories?[indexPath.row].colorVal = "00FDFF"
        }
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveData(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error Saving \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category, \(error)")
            }
        }
    }
    
    //MARK: - Add Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colorVal = UIColor.randomFlat().hexValue()
            
            self.saveData(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}

