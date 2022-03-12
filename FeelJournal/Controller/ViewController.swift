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
            let detectedFeel = nlpBrain.processSentimentAnalysis(input: text)
            var detectedFeelString = ""
            if detectedFeel == 0 {
                detectedFeelString = "Neutral"
            } else if detectedFeel < 0 {
                detectedFeelString = "Sad"
            } else {
                detectedFeelString = "Happy"
            }
            self?.createItem(title: text, body: "", feeling: detectedFeelString, feelingIndex: detectedFeel)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = journalData[indexPath.row]
        if editingStyle == .delete {
            self.deleteItem(item: item)
        }
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

