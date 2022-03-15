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
            getAnalytics()
        } catch {
            print("Cannot get all items")
        }
    }
    
    func getAnalytics() {
        var sum: Double = 0
        var sum7days: Double = 0
        var count7days: Int = 0
        for journal in journalData {
            sum += journal.feelingIndex
            if (Date() - journal.createdAt!).day! <= 7 {
                sum7days += journal.feelingIndex
                count7days += 1
            }
        }
        if journalData.count > 0 {
            let average: Double = sum / Double(journalData.count)
            feelAverage = average == 0 ? "Neutral" : average < 0 ? "Sad" : "Happy"
        } else {
            feelAverage = "No Data"
        }
        if count7days > 0 {
            let average: Double = sum7days / Double(count7days)
            feelAverage7days = average == 0 ? "Neutral" : average < 0 ? "Sad" : "Happy"
        } else {
            feelAverage7days = "No Data"
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
            print("Cannot create item")
        }
    }

    func deleteItem(item: JournalEntryItem) {
        context.delete(item)

        do {
            try context.save()
            getAllItems()
        } catch {
            print("Cannot delete item")
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
            print("Cannot update item")
        }
    }
}

extension Date {
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}

let dataManager: DataManager = DataManager()
