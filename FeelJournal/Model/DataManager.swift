//
//  DataManager.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 12/03/22.
//

import Foundation
import UIKit

struct DataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems() {
        do {
            journalData = try context.fetch(JournalEntryItem.fetchRequest()).reversed()
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

let dataManager: DataManager = DataManager()
