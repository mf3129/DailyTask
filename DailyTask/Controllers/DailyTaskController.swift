//
//  ViewController.swift
//  DailyTask
//
//  Created by Makan Fofana on 9/24/18.
//  Copyright © 2018 Makan Fofana. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class DailyTaskController: SwipeTableViewController {
    
    var pendingItems: Results<Item>?
    let realm = try! Realm()

    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext | CORE DATA
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.separatorStyle = .none
//        if let items = defaults.array(forKey: "itemArrayList") as? [Item] {
//            itemArray = items
//        }
        
    }


    //MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
            
            //tableView.dequeueReusableCell(withIdentifier: "ItemListCell", for: indexPath)
        
        if let item = pendingItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
    
            let previousColor =  UIColor(hexString: (selectedCategory?.Color)!)
            // let chosenColor = UIColor(named: (selectedCategory?.Color)!)
            
            if let Color = previousColor!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(pendingItems!.count)) {
                 cell.backgroundColor = Color
                 cell.textLabel?.textColor = ContrastColorOf(Color, returnFlat: true)
            }
            //Ternary Operator
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
    }

    

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = pendingItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
            }
        }   catch {
            print("Error saving done status, \(error)")
        }
    }
    
        tableView.reloadData()
    
//        pendingItems[indexPath.row].done = !pendingItems[indexPath.row].done
//
//        saveItemData()
        
//        if itemArray[indexPath.row].done == false { //REPLACED THIS CODE WITH THE CODE ABOVE.
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


//ADDING NEW ITEMS TO THE LIST
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertMessage = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //To occur when the user clicks the add item button
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving category \(error)")
                }
            }
            
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
    
    //MARK: - Manipulating the Model
    
//    func saveItemData() {  | USED FOR CORE DATA
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//
//        self.tableView.reloadData()
//    }
    
    
    func loadItems() {

        pendingItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        
        tableView.reloadData()
        
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        if let additionalPredicate = predicate {
        //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        //        } else {
        //            request.predicate = categoryPredicate
        //        }
        //
        //
        //        do {
        //            itemArray = try context.fetch(request)
        //        } catch {
        //            print("Error catching data from context \(error)")
        //        }-=
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = pendingItems?[indexPath.row] {
            do {
                try! realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting the category, \(error)")
            }
       }
    }
    
}
//MARK: - Search Bar Methods
extension DailyTaskController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        pendingItems = pendingItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        
        tableView.reloadData()
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)

    }
//
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            self.loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}


//ORIGINALLY FOR CORE DATA

//extension DailyTaskController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0 {
//            self.loadItems()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
