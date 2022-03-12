//
//  ViewController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 12/03/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(title: text, body: "", feeling: "Happy", feelingIndex: 1.0)
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = journalData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = "\(model.createdAt!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = journalData[indexPath.row]
        print(item)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let item = journalData[indexPath.row]
        
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.title
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newTitle: newName, newBody: "", newFeeling: "Happy", newFeelingIndex: 1.0)
            }))
            
            self.present(alert, animated: true)
        })
        editAction.backgroundColor = .orange
        
        let deleteAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.deleteItem(item: item)
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    
    //Core Data
    
    func getAllItems() {
        do {
            journalData = try context.fetch(JournalEntryItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
    }
    
    func createItem(title: String, body: String, feeling: String, feelingIndex: Double) {
        let newItem = JournalEntryItem(context: context)
        newItem.title = title
        newItem.createdAt = Date()
        newItem.body = body
        newItem.feeling = feeling
        newItem.feelingIndex = feelingIndex
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func deleteItem(item: JournalEntryItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func updateItem(item: JournalEntryItem, newTitle: String, newBody: String, newFeeling: String, newFeelingIndex: Double) {
        item.title = newTitle
        item.body = newBody
        item.feeling = newFeeling
        item.feelingIndex = newFeelingIndex
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
}

