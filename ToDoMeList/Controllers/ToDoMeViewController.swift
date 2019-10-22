//
//  ViewController.swift
//  ToDoMeList
//
//  Created by Yousef on 10/17/19.
//  Copyright © 2019 Yousef. All rights reserved.
//

import UIKit
import CoreData
class ToDoMeViewController: UITableViewController {
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category?
    {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
       

}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
      
        return cell
    }
    //MARK -- tableview delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "alert", message: "", preferredStyle: .alert)
        
               alert.addTextField { (textField) in
                   textField.placeholder = "enter new item"
                alertTextField = textField
               }
        let action =  UIAlertAction(title: "add new Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = alertTextField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        
        }
       
        alert.addAction(action)
     
        present(alert,animated: true,completion: nil)
        tableView.reloadData()
    }

    func saveItems()
    {
    
            do{
                try context.save()
            }
                
            catch
            {
                print("error save context \(error) ")
            }
        
            tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format :"parentCategory.name MATCHES %@",selectedCategory!.name!)
        print(categoryPredicate)
        if let additionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , additionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        print(request.predicate!)
               do{
                   itemArray = try context.fetch(request)
                 
               }
               catch
               {
                   print("error when fetch result \(error)")
               }
        tableView.reloadData()
    }
}

extension ToDoMeViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending:true)]
        print("search bar")
        loadItems(with :request ,predicate: request.predicate)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
               {
                   loadItems()
                   DispatchQueue.main.async {
                   searchBar.resignFirstResponder()
                   }
                   
               }
    }
       
    
}

