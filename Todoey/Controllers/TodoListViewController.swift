//
//  ViewController.swift
//  Todoey
//
//  Created by lichih hsu on 12/26/17.
//  Copyright © 2017 AppMission. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoItem]()
    let defaults: UserDefaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let newItem = TodoItem()
//        newItem.title = "Find Mike"
//        newItem.done = true
//        itemArray.append(newItem)
//        
//        let newItem2 = TodoItem()
//        newItem2.title = "get milk"
//        itemArray.append(newItem2)
//       
//        let newItem3 = TodoItem()
//        newItem3.title = "get milk"
//        itemArray.append(newItem3)
//        
//        let newItem4 = TodoItem()
//        newItem4.title = "get milk"
//        itemArray.append(newItem4)
       
        
        loadItems()
        
//        if let items = defaults.array(forKey: "Todoey") {
//            itemArray = items as! [TodoItem]
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Tableiview Datasoruce Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // print("cell for row")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
//        if itemArray[indexPath.row].done{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
       tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            
            let newmItem = TodoItem()
            newmItem.title = textField.text!
            self.itemArray.append(newmItem)
            
           // try? self.defaults.set(self.itemArray, forKey: "Todoey")
            
           self.saveItems()
           
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            //print(alertTextField.text)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK SaveItems
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data =  try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error encoding item array \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    func loadItems(){
        
        
            if let data = try? Data(contentsOf: dataFilePath!){
                let decoder = PropertyListDecoder()
                do {
                     itemArray = try decoder.decode([TodoItem].self, from: data)
                } catch {
                    print("Error decoding item array \(error)")
                }
               
            }
       
        
    }
}

