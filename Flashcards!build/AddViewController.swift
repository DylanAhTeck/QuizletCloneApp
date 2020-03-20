//
//  AddViewController.swift
//  AhTeckDylanHW6
//
//  Created by Dylan  Ah Teck on 11/1/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var questionTF: UITextView!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    let model = FlashcardsModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()

        questionTF.delegate = self
        answerTF.delegate = self
        saveButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TextfieldDeletegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == questionTF {
            questionTF.resignFirstResponder()
            answerTF.becomeFirstResponder()
        } else {
            answerTF.resignFirstResponder()
        }
        
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if ((questionTF.text.count > 0) && (answerTF.text?.count ?? <#default value#> > 0)){
//            self.saveButton.isEnabled = true
//        } else{
//            self.saveButton.isEnabled = false
//        }
//    }
    
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if let qtext = questionTF.text {
            if (updatedText.count > 0 && qtext.count > 0) {
                self.saveButton.isEnabled = true
            }
            else {
                self.saveButton.isEnabled = false
            }
        }
    
        if updatedText == "\n" { return false }
        return true
    }
    
    // Use this if you have a UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        
        if  updatedText == "\n" { return false }
        
        if let atext = answerTF.text {
            if (updatedText.count > 0 && atext.count > 0) {
                self.saveButton.isEnabled = true
            }
            else {
                self.saveButton.isEnabled = false
            }
        }
        
        return true
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        questionTF.text = ""
        answerTF.text = ""
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        if(model.checkAskedQuestion(potentialQuestion: questionTF.text))
        {
            
                let alertController = UIAlertController(title: "Warning!",
                                                        message: "The question you entered already exists, try a new question",
                                                        preferredStyle: .alert)
            let clearAction = UIAlertAction(title: "Ok", style: .cancel, handler:  { action in
                
                self.clear()
            })
            
                
                alertController.addAction(clearAction)
                self.present(alertController, animated: true, completion: nil)
        }
        
        else {
            guard let question = questionTF.text else {return}
            guard let answer = answerTF.text else {return}
            model.insert(question: question, answer: answer, favorite: favoriteSwitch.isOn, at: model.numberOfFlashcards())
            
            clear()
            self.dismiss(animated: true, completion: nil)
        }
        
        
       
    }
    
    //Helper = Clear textfields
    func clear() {
        questionTF.text = ""
        answerTF.text = ""
    }
    
    
    @IBAction func tapBackground(_ sender: UITapGestureRecognizer) {
        questionTF.resignFirstResponder()
        answerTF.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
