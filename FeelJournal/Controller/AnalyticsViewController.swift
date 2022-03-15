//
//  AnalyticsViewController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 15/03/22.
//

import UIKit

class AnalyticsViewController: UIViewController {

    @IBOutlet var filterControl: UISegmentedControl!
    @IBOutlet var feelingText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        feelingText.text = feelAverage7days
    }
    @IBAction func onFilterChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            feelingText.text = feelAverage7days
        } else {
            feelingText.text = feelAverage
        }
    }
    
}
