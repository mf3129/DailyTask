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

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    
    var itemArrays = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

    }

    
        //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrays.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let categoryItem = itemArrays[indexPath.row]
        
        cell.textLabel?.text = categoryItem.name
        
        return cell
        
        
    }

    
    
//ADDING NEW ITEMS TO THE LIST
    
    @IBAction func addBarButtonItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertMessage = UIAlertController(title: "Add Categories", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Categories", style: .default) { (action) in
            
            let newItem = Category()
            newItem.name = textField.text!
            
            self.itemArrays.append(newItem)
            
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
            destinationVC.selectedCategory = itemArrays[indexPath.row]
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
        
//        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
////        do {
////            itemArrays = try context.fetch(request)
////        } catch {
////            print("Error catching data from context \(error)")
////        }
////
////        tableView.reloadData()
    }
  
    
    
}
