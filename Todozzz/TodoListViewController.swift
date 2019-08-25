//
//  ViewController.swift
//  Todozzz
//
//  Created by Jean-Baptiste Chaubet on 24.08.19.
//  Copyright © 2019 Jean-Baptiste Chaubet. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController	 {

    let itemArray=["a","b","c"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
  


}

