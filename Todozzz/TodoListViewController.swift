//
//  ViewController.swift
//  Todozzz
//
//  Created by Jean-Baptiste Chaubet on 24.08.19.
//  Copyright © 2019 Jean-Baptiste Chaubet. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController	 {
    
    var itemArray=["a","b","c"]
    
    let defaults=UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray=items
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let res=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        res.textLabel?.text=itemArray[indexPath.row]
        return res
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new element", message: "message", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newTodo:String = alert.textFields![0].text!
            self.itemArray.append(newTodo)
            self.tableView.reloadData()
            self.defaults.set(self.itemArray,forKey: "TodoListArray")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("cancelled")
        }
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (textField) in
            textField.placeholder="item to be done"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

