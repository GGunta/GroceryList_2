//
//  GroceryTableViewController.swift
//  GroceryList
//
//  Created by gunta.golde on 04/08/2021.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {
    
    //  var groceries = [String]()
    var groceries = [Grocery]()
    var manageObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelagte = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelagte.persistentContainer.viewContext
        
        loadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        do {
            let result = try manageObjectContext?.fetch(request)
            groceries = result!
            tableView.reloadData()
        }catch{
            fatalError("Error in retrieving Grocery items")
        }
    }
    
    func saveData() {
        do{
            try manageObjectContext?.save()
        }catch{
            fatalError("Error in saving Grocery item")
        }
        loadData()
    }
    
    
    
    
    @IBAction func addNewItem(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Grocery Item", message: "What do you want to add?", preferredStyle: .alert)
        alertController.addTextField { textField in
            print(textField)
        }
        let addActionButton = UIAlertAction(title: "Add", style: .default) { AlertAction in
            
            let textField = alertController.textFields?.first
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: self.manageObjectContext!)
            let grocery = NSManagedObject(entity: entity!, insertInto: self.manageObjectContext)
            
            grocery.setValue(textField?.text, forKey: "item")
            self.saveData()
            
            /* self.groceries.append(textField!.text!)
             self.tableView.reloadData()*/
            
        }//addAction
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(addActionButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAllItems(_ sender: Any) {
        
        let deleteController = UIAlertController(title: "Delete all", message: "Do you really want to delete all your items?" , preferredStyle: .alert)
        
        let addDeleteButton = UIAlertAction(title: "Delete", style: .destructive) { alertAction in
            
            func deleteAllData(entity: String)
            {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.managedObjectContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                fetchRequest.returnsObjectsAsFaults = false
                
                do
            {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.deleteObject(managedObjectData)
                }
            } catch let error as NSError {
                print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
            }
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            deleteController.addAction(addDeleteButton)
            deleteController.addAction(cancelButton)
            
            self.present(deleteController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)
        
        //  cell.textLabel?.text = groceries[indexPath.row]
        let grocery = groceries[indexPath.row]
        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        cell.accessoryType = grocery.completed ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            manageObjectContext?.delete(groceries[indexPath.row])
        }
        self.saveData()
        
    }
    
       
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        groceries[indexPath.row].completed = !groceries[indexPath.row].completed
        self.saveData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "appInfo" {
            let viewCont = segue.destination as! AppearanceInfoViewController
            viewCont.infoText = "In Grocery shopping list app\n you can add items to a list,\n check that you got them,\n and delete one or all items from your list"
        }
        
    }
    
    
}
