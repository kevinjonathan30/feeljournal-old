//
//  JournalViewController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 12/03/22.
//

import UIKit

class JournalViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        dataManager.getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        reloadTableView()
    }
    
    @IBAction func addNewEntryButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toNewEntry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewEntry" {
            let secondVC = segue.destination as? AddNewJournalViewController
            secondVC?.delegate = self
        } else if segue.identifier == "toEditEntry" {
            let secondVC = segue.destination as? EditJournalViewController
            secondVC?.index = self.index
            secondVC?.delegate = self
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension JournalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = journalData[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? JournalCell {
            cell.UpdateCellView(item: model)
            return cell
        } else {
            return JournalCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        index = indexPath.row
        performSegue(withIdentifier: "toEditEntry", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = journalData[indexPath.row]
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete Note?", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
                dataManager.deleteItem(item: item)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}

extension JournalViewController: AddJournalDelegate, EditJournalDelegate {
    func reloadTableViewFromAnotherVC() {
        reloadTableView()
    }
}
