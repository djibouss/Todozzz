//
//  ViewController.swift
//  Todozzz
//
//  Created by Jean-Baptiste Chaubet on 24.08.19.
//  Copyright © 2019 Jean-Baptiste Chaubet. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController	 {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    var category : Category? {
        didSet{
            loadItems()

        }
    }
    
    
    let defaults=UserDefaults.standard
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            let dateFormatter = DateFormatter()
            let date:Date=item.dateCreated
            dateFormatter.dateFormat = "HH:mm:ss z"
            let dateCreated=dateFormatter.string(from: date)
            cell.textLabel?.text=item.title+":"+dateCreated
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text="no item added"
        }
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                    realm.delete(item)
                }
                
            }
                catch{
                    print("error while updating")
                }
            }
            
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
            
            
        }
        
    
    
    
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new element", message: "message", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let currentCategory=self.category{
                let item = Item()
                item.title = alert.textFields![0].text!
                do{
                    try self.realm.write {
                        self.realm.add(item)
                        currentCategory.items.append(item)
                    }
                }
                catch{
                    print(error)
                }
                self.loadItems()
                
            }
            
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
    
    
    
    func loadItems(){
        todoItems = category?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
}

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems=todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
}

