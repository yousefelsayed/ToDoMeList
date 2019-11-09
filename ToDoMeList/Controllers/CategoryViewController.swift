//
//  CategoryViewController.swift
//  ToDoMeList
//
//  Created by Yousef on 10/21/19.
//  Copyright © 2019 Yousef. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: SwipeViewController {
    var categories = [Category]()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
loadCategories()
       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name ?? "No Categories added yet"
        return cell
        
    }
   

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textInput = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "Do You want To Add Category", preferredStyle: .alert)
       
            alert.addTextField { (textField) in
               textField.placeholder = "Add new Category"
            textInput = textField
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Category(context: self.context)
            newItem.name = textInput.text!
            self.categories.append(newItem)
            self.saveCategories()
        }
            alert.addAction(action)
               
        present(alert,animated: true,completion: nil)
    }
    
    func saveCategories()
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
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest())
    {
       do {
        categories =   try context.fetch(request)
        } catch  {
            print("error when fetching context \(error)")
        }
        tableView.reloadData()
    }
    //Mark - Delagate Methodes
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Item", sender: self)
        
    }
    override func updateModel(at indexpath: IndexPath) {
    context.delete(categories[indexpath.row])
    categories.remove(at: indexpath.row)
            
       saveCategories()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! ToDoMeViewController
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVc.selectedCategory = categories[indexPath.row]
        }
        
    }
}

