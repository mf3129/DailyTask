//
//  ViewController.swift
//  DailyTask
//
//  Created by Makan Fofana on 9/24/18.
//  Copyright © 2018 Makan Fofana. All rights reserved.
//

import UIKit

class DailyTaskController: UITableViewController {

    let defaults = UserDefaults.standard
    
    
    var itemArray = ["Work On 22 HALO", "FINISH APP DESIGN COURSE", "Workout", "Typing Lessons", "F/P"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "itemArrayList") as? [String] {
            itemArray = items
        }
    }

//MARK - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }

//MARK TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //ADDING NEW ITEMS TO THE LIST
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertMessage = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //To occur when the user clicks the add item button
            
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "itemArrayList")
            
            self.tableView.reloadData()
        }
        
        alertMessage.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Item To List"
            print(alertTextField.text)
            textField = alertTextField
        }
   
        alertMessage.addAction(action)
        
        present(alertMessage, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
