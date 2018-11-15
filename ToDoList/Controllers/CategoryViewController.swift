//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Device Lab 3 on 14/11/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategories()
    }
    
    
    
    //MARK: ADDING A CATEGORY
    
    @IBAction func clickedAddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            //What should happen when add item button is pressed
            
            
            
            let newCategory = Category(context: self.context)
            
           newCategory.categoryName = textField.text!
            
            self.categoryArray.append(newCategory)
            
            //To update the array everytime we add a new item
            
            self.tableView.reloadData()
        }
        
        //Adding a textField to an alert
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            
            self.saveCategories()
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: Table View DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
         cell.textLabel?.text = categoryArray[indexPath.row].categoryName
        
        
        
        //Normal Version
        
        //        if arrayItems[indexPath.row].checked == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        performSegue(withIdentifier: "goToItemsView", sender: self)
        
        
         saveCategories()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        //HELPS US TO GO THE SELECTED CATEGORY
        
        if let rowIndexPath = tableView.indexPathForSelectedRow{
            
            destinationVC.selectedCategory = categoryArray[rowIndexPath.row]
        }
        
    }
    
    
    
    //MARK: SAVE METHOD
    
    func saveCategories(){
        
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
    
    func loadCategories(with fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()){
        
        
        do{
            categoryArray = try context.fetch(fetchRequest)
        }
        catch{
            print(error)
        }
        
        tableView.reloadData()
        
    }
    


}
