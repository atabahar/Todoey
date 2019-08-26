//
//  ViewController.swift
//  Todoey
//
//  Created by Ata Bahar on 7/23/19.
//  Copyright © 2019 atabahar. All rights reserved.

// Control dragged from Search Bar Icon to Yellow Circle Todoey, click Show
import UIKit
import CoreData

class TodoListViewController: UITableViewController {

// Making an Array of Item Objects
    var itemArray = [Item]()
// didSet means what happens when a value get set to a new value
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }

    // Tapping in the persistentContainer at App Delegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       // Gotta be in Global Constant variable to access it below lines, Here we turn our ItemArray to a .plist
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

// dequeueReusableCel re-use the created cell over and over that's why we make an Item class and Dictionary, Up and Swift file, 
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
// Ternary operator ==>
// If we have condition and we check to see if it's false or true, then set the value depending on true or false
// Structure example = condition ? True : False
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    //MARK: - TableView Delegate Methods
    
// This one for selecting the Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
// This is for deleting the Item when you click
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
// Sets the done property in the Item to the opposite of what it is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()
        
// Getting rid of Grey Color when you select the row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
// Creating an empty Local Variable TextField
        var userTextField = UITextField()
        
// Creating Alert to add ToDo's
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Todoey", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = userTextField.text!
            newItem.done = false
// .parentCategory is available to us because we created Relationship in DataModel
            newItem.parentCategory = self.selectedCategory
            
// Shows what will happen once the user clicks the Add Item Button on our UIAlert
            self.itemArray.append(newItem)
//      itemArray.append(userTextField.text ?? "New item") diyebilirdik
            
            self.saveItems()
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new todoey"
// Assigning user's message in our empty Local Variable TextField and Display, Disappers when user click
            userTextField = alertTextField

        }
       
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model Manupulation Methods
    
    func saveItems() {
        
        // Then initialize it
        do {
            try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        // in order to add a New Data (message)
        self.tableView.reloadData()
    }
// with request parameter is so we can call this method somewhere else like in extension
// Default value is Item.fetchRequest() in case we call loadItems without parameters
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
// First step of putting the date to its category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
            
        } else {
            
            request.predicate = categoryPredicate
        }
        
            do {
                itemArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
        
        tableView.reloadData()
    }
}
//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
        let request : NSFetchRequest<Item> = Item.fetchRequest()
// Shows how we want to query our data, Making the case insensetive with [cd]
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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
