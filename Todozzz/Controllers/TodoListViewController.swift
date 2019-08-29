//
//  ViewController.swift
//  Todozzz
//
//  Created by Jean-Baptiste Chaubet on 24.08.19.
//  Copyright © 2019 Jean-Baptiste Chaubet. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController	 {
    
    var itemArray = [Item]()
    
    var category : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let defaults=UserDefaults.standard
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text=item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        let item = itemArray[indexPath.row]
        item.done = !item.done
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveData()
        
    }
    
    
    
    //MARK - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new element", message: "message", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let item = Item(context: self.context)
            item.title = alert.textFields![0].text!
            item.done=false
            item.parentCategory=self.category
            self.itemArray.append(item)
            self.tableView.reloadData()
            
            self.saveData()
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
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("error while saving, \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        if let additionalPredicate = predicate {
              request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate=categoryPredicate
        }
      
        do{
            itemArray = try context.fetch(request)
            
        }
        catch{
            print("error while fetching data")
        }
        tableView.reloadData()
    }
    
    
    
    
}

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors=[sortDescriptor]
        loadItems(with: request,predicate: predicate)
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

