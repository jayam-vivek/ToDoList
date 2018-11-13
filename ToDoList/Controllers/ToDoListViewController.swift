//
//  ViewController.swift
//  ToDoList
//
//  Created by Device Lab 3 on 12/11/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{
    
    var arrayItems = [Item]()
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
 
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
      
        
    }
    
    
    //MARK: Table View DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = arrayItems[indexPath.row].itemName
        
        cell.accessoryType = arrayItems[indexPath.row].checked ? .checkmark : .none
        
        //Normal Version
        
//        if arrayItems[indexPath.row].checked == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK: Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //used to avoid checkmark problems when we scroll down in case of many items
        
        arrayItems[indexPath.row].checked = !arrayItems[indexPath.row].checked
        
        saveItems()
        
        
        //Normal Version
//        if arrayItems[indexPath.row].checked == false{
//            arrayItems[indexPath.row].checked = true
//
//        }else{
//            arrayItems[indexPath.row].checked = false
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Adding an Item
    
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in
            //What should happen when add item button is pressed
            
          let newItem = Item()
            
            newItem.itemName = textField.text!
            
            self.arrayItems.append(newItem)
            
            //To update the array everytime we add a new item
            
            self.tableView.reloadData()
        }
        
        //Adding a textField to an alert
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            self.saveItems()
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: SAVE METHOD
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let writeData = try encoder.encode(arrayItems)
            try writeData.write(to : filePath!)
            
        }catch{
            print(error)
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: RETRIEVE DATA
    func loadItems(){
        if let readData = try? Data(contentsOf: filePath!){
            let decoder = PropertyListDecoder()
            do{
                arrayItems = try decoder.decode([Item].self, from: readData)
            }catch{
                print(error)
            }
           
        }
    }
    

}

