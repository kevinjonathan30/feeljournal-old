//
//  AddNewJournalViewController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 12/03/22.
//

import UIKit

protocol AddJournalDelegate {
    func reloadTableViewFromAnotherVC()
}

class AddNewJournalViewController: UIViewController {
    
    var delegate: AddJournalDelegate?

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyTextField.delegate = self
        bodyTextField.textColor = .lightGray
        bodyTextField.text = "What's new? start typing here..."
    }
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let trimmed = bodyTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed != "What's new? start typing here..." && trimmed != "" {
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
            dataManager.createItem(title: titleText, body: trimmed, feeling: detectedFeelString, feelingIndex: detectedFeel)
            self.delegate?.reloadTableViewFromAnotherVC()
            navigationController?.popViewController(animated: true)
        }
    }
}

extension AddNewJournalViewController: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        if self.bodyTextField.textColor == .lightGray && self.bodyTextField.isFirstResponder {
            self.bodyTextField.text = nil
            self.bodyTextField.textColor = .black
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if self.bodyTextField.text.isEmpty || self.bodyTextField.text == "" {
            self.bodyTextField.textColor = .lightGray
            self.bodyTextField.text = "What's new? start typing here..."
        }
    }
}
