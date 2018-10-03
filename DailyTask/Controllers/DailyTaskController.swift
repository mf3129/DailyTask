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
    
    var itemArray = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Work On 22 HALO"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "One"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Done"
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "Hello"
        itemArray.append(newItem4)
        
        if let items = defaults.array(forKey: "itemArrayList") as? [Item] {
            itemArray = items
        }
        
    }


//MARK - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary Operator
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }

    

//MARK TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        if itemArray[indexPath.row].done == false { //REPLACED THIS CODE WITH THE CODE ABOVE.
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


//ADDING NEW ITEMS TO THE LIST
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertMessage = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //To occur when the user clicks the add item button
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)

            self.defaults.set(self.itemArray, forKey: "itemArrayList")
            
            self.tableView.reloadData() 
        }
        
        
        alertMessage.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Item To List"
//            print(alertTextField.text)
            textField = alertTextField
        }
   
        
        alertMessage.addAction(action)
        
        present(alertMessage, animated: true, completion: nil)
        
    }
    
    
  }


