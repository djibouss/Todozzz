//
//  CategoryViewController.swift
//  Todozzz
//
//  Created by Jean-Baptiste Chaubet on 27.08.19.
//  Copyright © 2019 Jean-Baptiste Chaubet. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray=[Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text=category.name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.category = categoryArray[indexPath.row]
        }
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "message", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let category = Category(context: self.context)
            category.name = alert.textFields![0].text!
            self.categoryArray.append(category)
            self.tableView.reloadData()
            self.saveData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("cancelled")
        }
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (textField) in
            textField.placeholder="new category"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveData(){
        do{
            try context.save()}
        catch{
            print(error)
        }
    }
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)}
        catch{
            print("error while fetching categories")
        }
        tableView.reloadData()
    }
    
}
