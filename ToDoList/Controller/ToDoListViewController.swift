//
//  ViewController.swift
//  ToDoList
//
//  Created by Asad Masroor on 23/02/2019.
//  Copyright © 2019 Asad Masroor. All rights reserved.
//

import UIKit
 import RealmSwift

class ToDoListViewController: UITableViewController {
    
     let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
        loadItems()
            
        }
    }
    
    var toDoItems: Results<Item>?
    var dindexpath = 0;
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
   


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        tap.numberOfTapsRequired = 2
//        tableView.addGestureRecognizer(tap)
        
//        loadItems()
    }
    


    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    ///////////////////////////////////////////
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if let item = toDoItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    item.done = !item.done
                    
                 
                }
            } catch {
                print("Error saving item \(error)")
            }
            
            
        }
        
        
        
        dindexpath = indexPath.row
        

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
       
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (UIAlertAction) in
            //Setting the context
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem1 = Item()
                        
                        newItem1.title = textField.text!
                        newItem1.done = false
                        newItem1.dateCreated = Date()
                        currentCategory.items.append(newItem1)
                    
                        self.realm.add(newItem1)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error saving item \(error)")
                }
        
        }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
          
        }
        
        present(alert, animated: true, completion: nil )
        
        
        
     
    }
    
    //MARK - Edit items
    
//    @objc func doubleTapped() {
//
//        var textField = UITextField()
//
//        let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Done", style: .default) { (UIAlertAction) in
//            //Setting the context
//
//
//
//            self.toDoItems[self.dindexpath].title = textField.text!
//
//            self.saveItems()
//
//
//        }
//
//        alert.addAction(action)
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Enter new name"
//            textField = alertTextField
//
//        }
//
//        present(alert, animated: true, completion: nil )
//
//    }
    

    
    // MARK - Model evaluation method
    
    func saveItems(item: Item) {
        
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving item \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
    

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

       
        tableView.reloadData()
    
    }
}
//MARK - Searchbar methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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


