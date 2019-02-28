//
//  ViewController.swift
//  ToDoList
//
//  Created by Asad Masroor on 23/02/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
            
        }
    }
    
    var itemArray = [Item]()
    var dindexpath = 0;
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(tap)
        
        loadItems()
    }
    


    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    ///////////////////////////////////////////
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        dindexpath = indexPath.row
        
        saveItems()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
       
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (UIAlertAction) in
            //Setting the context
            
            let newItem1 = Item(context: self.context)
           
            
            newItem1.title = textField.text!
            newItem1.done = false
            newItem1.parentCategory = self.selectedCategory
            self.itemArray.append(newItem1)
            
            self.saveItems()
        
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
          
        }
        
        present(alert, animated: true, completion: nil )
        
     
    }
    
    //MARK - Edit items
    
    @objc func doubleTapped() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Done", style: .default) { (UIAlertAction) in
            //Setting the context
            

            
            self.itemArray[self.dindexpath].title = textField.text!
            
            self.saveItems()
        
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new name"
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil )
        
    }
    

    
    // MARK - Model evaluation method
    
    func saveItems() {
        
        
        do {
           try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
         let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let inputPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
        }
    

    }
//MARK - Searchbar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: searchPredicate)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                
            }
            
        }
    }
    
}


