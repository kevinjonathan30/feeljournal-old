//
//  AnalyticsViewController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 15/03/22.
//

import Charts
import UIKit

class AnalyticsViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var pieChartView: PieChartView!

    @IBOutlet var filterControl: UISegmentedControl!
    @IBOutlet var feelingText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        feelingText.text = feelAverage7days
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pieChartView.delegate = self
        generateChart(requestedData: "7days")
    }
    
    func generateChart(requestedData: String) {
//        pieChart.frame = CGRect(x: 0, y: 0, width: pieChartView.frame.width, height: pieChartView.frame.width)
        
        var entries = [ChartDataEntry]()
        
        var happy: Int = 0, neutral: Int = 0, sad: Int = 0
        
        for journal in journalData {
            if requestedData == "7days" {
                if (Date() - journal.createdAt!).day! <= 7 {
                    if journal.feeling == "Neutral" {
                        neutral += 1
                    } else if journal.feeling == "Sad" {
                        sad += 1
                    } else {
                        happy += 1
                    }
                }
            } else {
                if journal.feeling == "Neutral" {
                    neutral += 1
                } else if journal.feeling == "Sad" {
                    sad += 1
                } else {
                    happy += 1
                }
            }
        }
        if happy > 0 {
            entries.append(ChartDataEntry(x: Double(happy), y: Double(happy)))
        }
        if neutral > 0 {
            entries.append(ChartDataEntry(x: Double(neutral), y: Double(neutral)))
        }
        if sad > 0 {
            entries.append(ChartDataEntry(x: Double(sad), y: Double(sad)))
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.colorful()
        let data = PieChartData(dataSet: set)
        pieChartView.data = data
    }
    
    @IBAction func onFilterChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            feelingText.text = feelAverage7days
            generateChart(requestedData: "7days")
        } else {
            feelingText.text = feelAverage
            generateChart(requestedData: "alltime")
        }
    }
    
}
