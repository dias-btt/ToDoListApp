//
//  ViewController.swift
//  ToDoList_DocuSketch
//
//  Created by Диас Сайынов on 13.07.2023.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ToDoListViewController: SwipeTableViewController {
    
    var items: Results<Item>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: -- TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.textColor = UIColor(red: 0.08, green: 0.44, blue: 0.27, alpha: 1.00)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor(red: 0.08, green: 0.44, blue: 0.27, alpha: 1.00).cgColor
        cell.layer.cornerRadius = 15
        cell.clipsToBounds = true
        
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.name
            cell.accessoryType = item.done ? .checkmark : .none
        } else{
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    //MARK: -- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            } catch{
                print("Error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -- Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var addedItem = UITextField()
        
        let addAlert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Done", style: .default){ (action) in
                
            let newItem = Item()
            newItem.name = addedItem.text!
            newItem.dateCreated = Date()
            self.saveItems(item: newItem)
        }
        addAlert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Add something"
            addedItem = alertTextField
        }
        addAlert.addAction(alertAction)
        present(addAlert, animated: true)
    }
    
//MARK: - Data manipulation methods
    func loadItems(){
        items = realm.objects(Item.self).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func saveItems(item: Item){
        do{
            try realm.write{
                realm.add(item)
            }
        } catch{
            print("Error saving items \(error)")
        }
        self.tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = items?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch{
                print("Error deleting cell")
            }
        }
    }
    
}
