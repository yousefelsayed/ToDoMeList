//
//  ViewController.swift
//  ToDoMeList
//
//  Created by Yousef on 10/17/19.
//  Copyright © 2019 Yousef. All rights reserved.
//

import UIKit

class ToDoMeViewController: UITableViewController {
    var itemArray = [Item]()
let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print (filePath)
       
    let newItem1 = Item()
        newItem1.title = "Buy Egg"
        itemArray.append(newItem1)
    let newItem2 = Item()
        newItem2.title = "Go Gym"
         itemArray.append(newItem2)
        loadItems()

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
            let newItem = Item()
            newItem.title = alertTextField.text!
            self.itemArray.append(newItem)
            self.saveItems()
        
        }
       
        alert.addAction(action)
     
        present(alert,animated: true,completion: nil)
    }

    func saveItems()
    {
        let encoder = PropertyListEncoder()
            do{
                let data = try encoder.encode(itemArray)
                try data.write(to: filePath!)
            }
                
            catch
            {
                print("error when encoding")
            }
        
            tableView.reloadData()
    }
    func loadItems()
    {
      if  let data = try?Data(contentsOf: filePath!)
      {
         let decoder = PropertyListDecoder()
        do{
            itemArray = try decoder.decode([Item].self, from: data)
        
        }
        catch
        {
            print("cann't decode")
        }
        }
       
        
    }
}

