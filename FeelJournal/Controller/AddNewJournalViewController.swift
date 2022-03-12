//
//  AddNewJournalViewController.swift
//  FeelJournal
//
//  Created by Kevin Jonathan on 12/03/22.
//

import UIKit

class AddNewJournalViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyTextField.delegate = self
        bodyTextField.textColor = .lightGray
        bodyTextField.text = "What's new? start typing here..."
    }
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        guard let field = bodyTextField, let text = field.text, !text.isEmpty else {
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
        print(detectedFeelString)
        var titleText = titleTextField.text
        if titleText == "" {
            titleText = "Untitled Note"
        }
        //self.createItem(title: text, body: "", feeling: detectedFeelString, feelingIndex: detectedFeel)
        dismiss(animated: true, completion: nil)
    }
}

extension AddNewJournalViewController: UITextViewDelegate {
    func textViewDidBeginEditing (_ textView: UITextView) {
        if self.bodyTextField.textColor == .lightGray && self.bodyTextField.isFirstResponder {
            print("Hello")
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
