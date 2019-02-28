//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Asad Masroor on 26/02/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
  
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }

    // MARK: - Table view data source
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCategory", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray?.count ?? 1
    }
    
    
    // MARK: - Table delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexpath.row]
        }
        
    }

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            
            let newCategory = Category()
            
            newCategory.name = textfield.text!
            
        
            
            self.saveCategory(category: newCategory)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textfield =  alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - SAVING AND LOADING METHODS
    
    
    func saveCategory(category: Category) {
        
        do {
            try realm.write {
               realm.add(category)
            }
        } catch {
            print("Error from saving categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    func loadCategory() {
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
 

}
