//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Łukasz Tatarynowicz on 23/01/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryList = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryList[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryList[indexPath.row]
        }
    }
    
    //MARK:- Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context in category view \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryList = try context.fetch(request)
        } catch{
            print("Error fetching data from category context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK:- Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category to list", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category to list"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            if (textField.text != "") {
                let category = Category(context: self.context)
                category.name = textField.text!
                self.categoryList.append(category)
                self.saveCategories()
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
