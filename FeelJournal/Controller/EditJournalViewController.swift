//
//  EditJournalViewController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 14/03/22.
//

import UIKit

protocol EditJournalDelegate {
    func reloadTableViewFromAnotherVC()
}

class EditJournalViewController: UIViewController {
    
    var delegate: AddJournalDelegate?
    var index: Int = 0
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = journalData[index].title
        bodyTextField.text = journalData[index].body
        bodyTextField.delegate = self
        if bodyTextField.text == "" {
            self.bodyTextField.textColor = .lightGray
            self.bodyTextField.text = "Start writing here..."
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        let trimmed = bodyTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed != "Start writing here..." && trimmed != "" {
            let detectedFeel = nlpBrain.processSentimentAnalysis(input: trimmed)
            var detectedFeelString = ""
            if detectedFeel == 0 {
                detectedFeelString = "Neutral"
            } else if detectedFeel < 0 {
                detectedFeelString = "Sad"
            } else {
                detectedFeelString = "Happy"
            }
            var titleText = titleTextField.text!
            if titleText == "" {
                titleText = "Untitled Note"
            }
            dataManager.updateItem(item: journalData[index], newTitle: titleText, newBody: trimmed, newFeeling: detectedFeelString, newFeelingIndex: detectedFeel)
            self.delegate?.reloadTableViewFromAnotherVC()
            navigationController?.popViewController(animated: true)
        } else {
            var titleText = titleTextField.text!
            if titleText == "" {
                titleText = "Untitled Note"
            }
            dataManager.updateItem(item: journalData[index], newTitle: titleText, newBody: "", newFeeling: "Neutral", newFeelingIndex: 0)
            self.delegate?.reloadTableViewFromAnotherVC()
            navigationController?.popViewController(animated: true)
        }
    }
}

extension EditJournalViewController: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        if self.bodyTextField.textColor == .lightGray && self.bodyTextField.isFirstResponder {
            self.bodyTextField.text = nil
            self.bodyTextField.textColor = .black
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if self.bodyTextField.text.isEmpty || self.bodyTextField.text == "" {
            self.bodyTextField.textColor = .lightGray
            self.bodyTextField.text = "Start writing here..."
        }
    }
}
