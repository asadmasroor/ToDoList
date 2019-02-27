//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Asad Masroor on 26/02/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    
   
    
    var categoryArray = [Category]()
  
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
    }

    // MARK: - Table view data source
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCategory", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    
    // MARK: - Table delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexpath.row]
        }
        
    }

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textfield.text
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
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
    
    
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print("Error from saving categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest() ) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
    }
    
 

}
