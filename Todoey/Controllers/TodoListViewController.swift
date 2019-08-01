//
//  ViewController.swift
//  Todoey
//
//  Created by Ata Bahar on 7/23/19.
//  Copyright © 2019 atabahar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

// Making an Array of Item Objects
    var itemArray = [Item]()
// Gotta be in Global Constant variable to access it below lines, Here we turn our ItemArray to a .plist
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)

        loadItems()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

// dequeueReusableCel re-use the created cell over and over that's why we make an Item class and Dictionary, Up and Swift file
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
// Ternary operator ==>
// If we have condition and we check to see if it's false or true, then set the value depending on true or false
// Structure example = condition ? True : False
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
// This one for selecting the Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
// Sets the done property in the Item to the opposite of what it is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()
        
// Getting rid of Grey Color when you select the row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
// Creating an empty Local Variable TextField
        var userTextField = UITextField()
        
// Creating Alert to add ToDo's
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Todoey", style: .default) { (action) in
// Calling our Item class and assigning its title to our empty Local Variable TextField
            let newItem = Item()
            newItem.title = userTextField.text!
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
    func saveItems() {
        let encoder = PropertyListEncoder()
        // Then initialize it
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        // in order to add a New Data (message)
        self.tableView.reloadData()
    }
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
           
           let decoder = PropertyListDecoder()
            
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

