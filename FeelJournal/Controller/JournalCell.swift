//
//  JournalCell.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 13/03/22.
//

import UIKit

class JournalCell: UITableViewCell {
    @IBOutlet weak var feeling: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    func UpdateCellView(item: JournalEntryItem) {
        feeling.text = item.feeling == "Happy" ? "😀" : item.feeling == "Neutral" ? "😐" : "😢"
        title.text = item.title
        body.text = item.body
        createdAt.text = "\(item.createdAt!.formatted(date: .abbreviated, time: .omitted))"
    }
}
