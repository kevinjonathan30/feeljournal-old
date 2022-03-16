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
    
    var happyDataEntry = PieChartDataEntry(value: 0)
    var neutralDataEntry = PieChartDataEntry(value: 0)
    var sadDataEntry = PieChartDataEntry(value: 0)
    
    var numberOfFeelingsDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feelingText.text = feelAverage7days
        pieChartView.chartDescription.text = ""
        pieChartView.drawHoleEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pieChartView.delegate = self
        generateChart(requestedData: "7days")
    }
    
    func generateChart(requestedData: String) {
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
        numberOfFeelingsDataEntries = []
        if happy > 0 {
            happyDataEntry.value = Double(happy)
            happyDataEntry.label = "Happy"
            numberOfFeelingsDataEntries.append(happyDataEntry)
        }
        if neutral > 0 {
            neutralDataEntry.value = Double(neutral)
            neutralDataEntry.label = "Neutral"
            numberOfFeelingsDataEntries.append(neutralDataEntry)
        }
        if sad > 0 {
            sadDataEntry.value = Double(sad)
            sadDataEntry.label = "Sad"
            numberOfFeelingsDataEntries.append(sadDataEntry)
        }
        
        let chartDataSet = PieChartDataSet(entries: numberOfFeelingsDataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(red: 88/255.0, green: 86/255.0, blue: 214/255.0, alpha: 1.0), UIColor(red: 126/255.0, green: 33/255.0, blue: 212/255.0, alpha: 1.0), UIColor(red: 150/255.0, green: 131/255.0, blue: 236/255.0, alpha: 1.0)]
        chartDataSet.colors = colors
        
        pieChartView.data = chartData
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

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
