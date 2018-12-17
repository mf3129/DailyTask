//
//  CategoryViewController.swift
//  DailyTask
//
//  Created by Makan Fofana on 10/23/18.
//  Copyright © 2018 Makan Fofana. All rights reserved.
//

import UIKit
// import CoreData
import RealmSwift
import ChameleonFramework



class CategoryViewController:  SwipeTableViewController {

    let realm = try! Realm()
    var itemArrays: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.separatorStyle = .none
    }
    
    
    
    
    
        //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrays?.count ?? 1 // NIL COALESCING OPERATOR
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
        if let category = itemArrays?[indexPath.row] {
            
            cell.textLabel?.text = category.name 
            
            cell.backgroundColor = UIColor(hexString: category.Color )
        
        }
        

        
        return cell
    }
    
    
    
    
//ADDING NEW ITEMS TO THE LIST
    
    @IBAction func addBarButtonItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertMessage = UIAlertController(title: "Add Categories", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Categories", style: .default) { (action) in
            
            let newItem = Category()
            newItem.name = textField.text!
            newItem.Color = UIColor.randomFlat.hexValue()
            
            self.save(category: newItem)
            
        }
        
        alertMessage.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add Category To List"
        }
        
        alertMessage.addAction(action)
        
        present(alertMessage, animated: true, completion: nil)
        
    }
    
    
//MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DailyTaskController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = itemArrays?[indexPath.row]
        }
    }
    
    
//MARK: Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadCategory() {
        
        itemArrays = realm.objects(Category.self)
        
         tableView.reloadData()
        
//        let request: NSFetchRequest<Categories> = Categories.fetchRequest()  ORIGINAL FOR CORE DATA
//        do {
//            itemArrays = try context.fetch(request)
//        } catch {
//            print("Error catching data from context \(error)")
//        }
    }
    
    //MARK: Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        //Update our data model
        if let categoryDeleted = self.itemArrays?[indexPath.row] {
            do {
                try! self.realm.write {
                    self.realm.delete(categoryDeleted)
                    // tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                }
            } catch {
                print("Error deleting the category, \(error)")
            }
        }
}
    
}

