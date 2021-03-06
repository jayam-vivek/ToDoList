//
//  ViewController.swift
//  ToDoList
//
//  Created by Device Lab 3 on 12/11/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var arrayItems = [Item]()
    
    var selectedCategory:Category? {
        
        //WE USE THIS PROPERTY SO THAT THE ITEMS WILL BE LOADED ONLY WHEN A CATEGORY IS SELECTED
        
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
 
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
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
        
        
        // DELETE OPERATIONS
        
//        context.delete(arrayItems[indexPath.row])
//        arrayItems.remove(at: indexPath.row)
        
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
            
     
            
          let newItem = Item(context: self.context)
            
            newItem.itemName = textField.text!
            newItem.checked = false
            
            //THIS IS DONE TO KNOW THE SELECTED CATEGORY BASED ON RELATIONSHIPS WE CREATED
            
            newItem.itemToCategory = self.selectedCategory
            
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
     
        do{
            try context.save()
        }catch{
            print(error)
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: RETRIEVE DATA
    
    //HERE WE ARE USING THE METHOD WITH EXTERNAL AND INTERNAL PARAMETERS
    //WITH IS A EXTERNAL PARAMETER
    //FETCHREQUEST IS A INTERNAL PARAMATER
    //WE ALSO PROVIDED THE DEFAULT VALUE SO IT WILL NOT BE A PROBLEM IF NO VALUE IS PROVIDED
    // HERE WE ARE TAKING SECOND PARAMETER AS PREDICATE BECAUSE IT SHOULD OVERRIDE THE SEARCH BAR PREDICATE AND WE CREATE A COMPOUND PREDICATE
    //WE PROVIDE A DEFAULT VALUE NIL TO PREDICATE SO THAT WE CAN LOAD THE DATA WITHOUT ARGUMENTS
    
    func loadItems(with fetchRequest: NSFetchRequest<Item> = Item.fetchRequest(),recievedPredicate : NSPredicate? = nil){
        
        
        let categoryPredicte = NSPredicate(format: "itemToCategory.categoryName MATCHES %@", selectedCategory!.categoryName!)
        
        //USING IF LET TO PERFORM OPTIONAL BINDING BECAUSE WE HAVE AN OPTIONAL ARGUEMENT
        
        if let recievedSearchBarPredicate = recievedPredicate{
            
            //WHEN OPTIONAL PREDICATE  IS NOT NIL
            
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicte,recievedSearchBarPredicate])
            fetchRequest.predicate = compoundPredicate
        }
        else{
            
            //WHEN OPTIONAL PREDICATE IS NIL
            
            fetchRequest.predicate = categoryPredicte
        }


        do{
            arrayItems = try context.fetch(fetchRequest)
        }
        catch{
            print(error)
        }

    tableView.reloadData()

}
    
                                     //OR
    
    //ANOTHER WAY
    
//    func loadItems(fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()){
//
//
//        do{
//            arrayItems = try context.fetch(fetchRequest)
//        }
//        catch{
//            print(error)
//        }
//
//        tableView.reloadData()
//
//    }

}

//MARK: Search Bar Implementation

extension ToDoListViewController : UISearchBarDelegate {
    
    //connected search bar delegate through storyboard
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
         let request : NSFetchRequest<Item> = Item.fetchRequest()
        //cd makes search insensitive
         let searchBarPredicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        
        let sortData = NSSortDescriptor(key: "itemName", ascending: true)
        request.sortDescriptors = [sortData]
        
        loadItems(with: request,recievedPredicate: searchBarPredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            // To Make the cursor disappear after reaching to original list
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    
        
        
       
        
    }
    
}
