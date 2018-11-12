//
//  ViewController.swift
//  ToDoList
//
//  Created by Device Lab 3 on 12/11/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{
    
    var hardCodedArrayItems = ["one","two","three"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Using UserDefaults
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
            hardCodedArrayItems = items
        }
        
    }
    
    
    //MARK: Table View DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hardCodedArrayItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = hardCodedArrayItems[indexPath.row]
        
        return cell
    }
    
    //MARK: Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Adding an Item
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            //What should happen when add item button is pressed
            
            self.hardCodedArrayItems.append(textField.text!)
            
            //To update the array everytime we add a new item
            
            self.tableView.reloadData()
        }
        
        //Adding a textField to an alert
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            self.defaults.set(self.hardCodedArrayItems, forKey: "ToDoListArray")
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

}

