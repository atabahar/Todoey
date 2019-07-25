//
//  ViewController.swift
//  Todoey
//
//  Created by Ata Bahar on 7/23/19.
//  Copyright © 2019 atabahar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

// They are cell 1, cell 2
    let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
// This one for selecting the Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

// Checks it if the current cell is selected and has a checkMark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
// If so Uncheck
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
// Getting rid of Grey Color when you select the row
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

