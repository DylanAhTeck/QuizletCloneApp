//
//  ViewController.swift
//  AhTeckDylanHW5
//
//  Created by Dylan  Ah Teck on 10/20/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    //Singleton
    private let shared = FlashcardsModel.shared
    
    
    let star = UIImage(named: "star") as UIImage?
    let starFilled = UIImage(named: "starFilled") as UIImage?
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
     
        if(shared.numberOfFlashcards() == 0)
        {
            self.messageLabel.text = "There are no more flashcards."
            self.view.backgroundColor = UIColor.yellow
            
            for recognizer in view.gestureRecognizers ?? [] {
                view.removeGestureRecognizer(recognizer)
            }
            let singleTap = UITapGestureRecognizer(target: self,
                                                   action: #selector(emptySingleTapped))
            
            self.view.addGestureRecognizer(singleTap)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(emptyDoubleTapped))
            doubleTap.numberOfTapsRequired = 2
            
            
            self.view.addGestureRecognizer(doubleTap)
            
            singleTap.require(toFail: doubleTap)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(emptyLeftSwipped))
            swipeLeft.direction = .left
            self.view.addGestureRecognizer(swipeLeft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(emptyRightSwipped))
            swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)
            
            favoriteSwitch.isHidden = true
            favoriteLabel.isHidden = true
        }
            
        else {
            
        let singleTap = UITapGestureRecognizer(target: self,
                                               action: #selector(singleTapped))
        self.view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        
        self.view.addGestureRecognizer(doubleTap)
        
        singleTap.require(toFail: doubleTap)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipped))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipped))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        messageLabel.text = shared.currentFlashcard()?.getQuestion()
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.lineBreakMode = .byWordWrapping
        
            favoriteSwitch.isHidden = false
            favoriteLabel.isHidden = false
            
       if let isFavorite = shared.currentFlashcard()?.isFavorite
       {
        if isFavorite {
            favoriteSwitch.setOn(true, animated: true)
        }
        else {
            favoriteSwitch.setOn(false, animated: true)
        }
       }
        
      
        
        let animator = UIViewPropertyAnimator(duration: 1,
                                              curve: UIView.AnimationCurve.easeInOut) {
                                                self.view.backgroundColor = UIColor.yellow
        }
            
        animator.startAnimation()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewDidLoad()
        
    }
    
    @objc func singleTapped() {
  
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.messageLabel.transform = CGAffineTransform(translationX: self.messageLabel.bounds.origin.x, y: self.messageLabel.bounds.origin.y - 500)
        }, completion: { (finished: Bool) in
            
            let flashcard = self.shared.randomFlashcard()
            self.shared.questionDisplayed = true
            self.messageLabel.text = flashcard?.getQuestion()
            
            if let isFavorite = self.shared.currentFlashcard()?.isFavorite
            {
                if isFavorite {
                    self.favoriteSwitch.setOn(true, animated: true)
                }
                else {
                    self.favoriteSwitch.setOn(false, animated: true)
                }
            }
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.messageLabel.transform = .identity
                self.view.backgroundColor = UIColor.yellow
            }, completion: nil)
        })
    }
    
    @objc func emptySingleTapped() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.messageLabel.transform = CGAffineTransform(translationX: self.messageLabel.bounds.origin.x, y: self.messageLabel.bounds.origin.y - 500)
        }, completion: { (finished: Bool) in
            
         
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.messageLabel.transform = .identity
                self.messageLabel.text = "There are no more flashcards."
                self.view.backgroundColor = UIColor.yellow
            }, completion: nil)
        })
        
    }
    
    @objc func emptyDoubleTapped() {
        
        if(self.messageLabel.text == "There are no more flashcards.")
        {
            let firstAnimator = UIViewPropertyAnimator(duration: 1,
                                                       curve: UIView.AnimationCurve.linear) {self.messageLabel.alpha = 0}
            
            firstAnimator.addCompletion { (position) in
                
                self.messageLabel.text = "Please add more flashcards."
                let animator = UIViewPropertyAnimator(duration: 1,
                                                      curve: UIView.AnimationCurve.linear)
                {
                    self.messageLabel.alpha = 1
                    self.view.backgroundColor = UIColor.green
                }
                animator.startAnimation()
            }
            firstAnimator.startAnimation()
        }
            
        else
        {
            let firstAnimator = UIViewPropertyAnimator(duration: 1,
                                                       curve: UIView.AnimationCurve.linear) {self.messageLabel.alpha = 0}
            
            firstAnimator.addCompletion { (position) in
                
                self.messageLabel.text = "There are no more flashcards."
                let animator = UIViewPropertyAnimator(duration: 1,
                                                      curve: UIView.AnimationCurve.linear)
                {
                    self.messageLabel.alpha = 1
                    self.view.backgroundColor = UIColor.yellow
                }
                animator.startAnimation()
            }
            firstAnimator.startAnimation()
        }
        
    }
    
    @objc func emptyLeftSwipped() {
        
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.messageLabel.transform = CGAffineTransform(translationX: self.messageLabel.bounds.origin.x - 400, y: self.messageLabel.bounds.origin.y)
        }, completion: { (finished: Bool) in
           
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.messageLabel.transform = .identity
                self.messageLabel.text = "There are no more flashcards."
                self.view.backgroundColor = UIColor.yellow
            }, completion: nil)
        })
        
    }
    
    @objc func emptyRightSwipped() {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.messageLabel.transform = CGAffineTransform(translationX: self.messageLabel.bounds.origin.x + 400, y: self.messageLabel.bounds.origin.y)
        }, completion: { (finished: Bool) in
            
           
           
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.messageLabel.transform = .identity
                self.messageLabel.text = "There are no more flashcards."
                self.view.backgroundColor = UIColor.yellow
            }, completion: nil)
        })
    }
    
    
    @objc func doubleTapped() {
      
        if(shared.questionDisplayed)
        {
            let firstAnimator = UIViewPropertyAnimator(duration: 1,
                                                       curve: UIView.AnimationCurve.linear) {self.messageLabel.alpha = 0}
            
            firstAnimator.addCompletion { (position) in
                let flashcard = self.shared.currentFlashcard()
                self.shared.questionDisplayed = false
                self.messageLabel.text = flashcard?.getAnswer()
                let animator = UIViewPropertyAnimator(duration: 1,
                                                      curve: UIView.AnimationCurve.linear)
                {
                    self.messageLabel.alpha = 1
                    self.view.backgroundColor = UIColor.green
                }
                animator.startAnimation()
            }
            firstAnimator.startAnimation()
        }
        
        else
        {
            let firstAnimator = UIViewPropertyAnimator(duration: 1,
                                                       curve: UIView.AnimationCurve.linear) {self.messageLabel.alpha = 0}
            
            firstAnimator.addCompletion { (position) in
                let flashcard = self.shared.currentFlashcard()
                self.shared.questionDisplayed = true
                self.messageLabel.text = flashcard?.getQuestion()
                
                let animator = UIViewPropertyAnimator(duration: 1,
                                                      curve: UIView.AnimationCurve.linear)
                {
                    self.messageLabel.alpha = 1
                    self.view.backgroundColor = UIColor.yellow
                }
                animator.startAnimation()
            }
            firstAnimator.startAnimation()
        }
    }
    
    @objc func leftSwipped() {
      
      
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.messageLabel.transform = CGAffineTransform(translationX: self.messageLabel.bounds.origin.x - 400, y: self.messageLabel.bounds.origin.y)
        }, completion: { (finished: Bool) in
            
            let flashcard = self.shared.nextFlashcard()
            self.shared.questionDisplayed = true
            self.messageLabel.text = flashcard?.getQuestion()
            
            
            if let isFavorite = self.shared.currentFlashcard()?.isFavorite
            {
                if isFavorite {
                    self.favoriteSwitch.setOn(true, animated: true)
                }
                else {
                    self.favoriteSwitch.setOn(false, animated: true)
                }
            }
            
         
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.messageLabel.transform = .identity
                self.view.backgroundColor = UIColor.yellow
            }, completion: nil)
        })
        
    }
    
 
    @objc func rightSwipped() {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.messageLabel.transform = CGAffineTransform(translationX: self.messageLabel.bounds.origin.x + 400, y: self.messageLabel.bounds.origin.y)
        }, completion: { (finished: Bool) in
            
            let flashcard = self.shared.previousFlashcard()
            self.shared.questionDisplayed = true
            self.messageLabel.text = flashcard?.getQuestion()
            
          
            if let isFavorite = self.shared.currentFlashcard()?.isFavorite
            {
                if isFavorite {
                    self.favoriteSwitch.setOn(true, animated: true)
                }
                else {
                    self.favoriteSwitch.setOn(false, animated: true)
                }
            }
            
            
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                self.messageLabel.transform = .identity
                self.view.backgroundColor = UIColor.yellow
            }, completion: nil)
        })
    }
    
    @IBAction func favoriteChanged(_ sender: UISwitch) {
        shared.toggleFavorite()
    }
    
    
    
}

