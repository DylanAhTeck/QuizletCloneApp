//
//  FlashcardsModel.swift
//  AhTeckDylanHW5
//
//  Created by Dylan  Ah Teck on 10/20/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import Foundation

class FlashcardsModel: NSObject, FlashcardsDataModel {
    
    private var flashcards = [Flashcard]()
    private var currentIndex: Int?
    var questionDisplayed: Bool
    
    //Singleton
    public static let shared = FlashcardsModel()
  
    // properties/instance variable
    var filepath:String
    
    
    override init()
    {
        self.questionDisplayed = false
        self.currentIndex = 0;
        
        // find the Documents directory
        let manager = FileManager.default
        filepath = ""
        if let url = manager.urls(for: .documentDirectory,
                                  in: .userDomainMask).first {
            filepath = url.appendingPathComponent("PropertyList.plist").path
            print("filepath=\(filepath)")
        
            
            
            //read from plist file if it exists
            if manager.fileExists(atPath: filepath){
                if let flashcardsArray = NSArray(contentsOfFile: filepath){
                    for dict in flashcardsArray {
                        //converting from NSString to String
                    
                        let flashcardDict = dict as! [String: String]
                        if let questionString = flashcardDict["questionKey"], let answerString = flashcardDict["answerKey"], let favoriteString = flashcardDict["favoriteKey"] {
                            
                            var favorite : Bool
                            if favoriteString == "true" {
                                favorite = true
                            }
                            else {
                                favorite = false
                            }
                            
                            let flashcard = Flashcard(question: questionString,  answer: answerString, isFavorite: favorite)
                            flashcards.append(flashcard)
                        }
                        
                        
                    
                    }
                }
                    
                    
    
//            do {
//                try msgString.write(toFile: filepath,
//                                    atomically: true, encoding: .utf8)
//            } catch {
//                print("Could not save to file")
//            }
            
        }
            else {
                let flashcard1 = Flashcard(question: "What is the Capital of Mauritius?", answer: "Port Louis", isFavorite: true)
                let flashcard2 = Flashcard(question: "What is the Capital of Australia?", answer: "Canberra", isFavorite: false)
                let flashcard3 = Flashcard(question: "What is the Capital of England?", answer: "London", isFavorite: false)
                let flashcard4 = Flashcard(question: "What is the Capital of South Africa?", answer: "Johannesburg", isFavorite: true)
                let flashcard5 = Flashcard(question: "What is the Capital of Singapore?", answer: "Singapore", isFavorite: true)
                
                
                flashcards = [flashcard1, flashcard2, flashcard3, flashcard4, flashcard5]
            }
            
        }
        
        if flashcards.count == 0 {
            currentIndex = nil
        }
        else {
            currentIndex = 0
        }
        
        super.init()
        
    }
    
    
    // Returns number of flashcards in model
    func numberOfFlashcards() -> Int{
    return flashcards.count
    }
    
    // Returns a flashcard – sets currentIndex appropriately
    func randomFlashcard() -> Flashcard?{
        
        if(flashcards.count == 1)  {
            currentIndex = 0
            return flashcard(at: 0)
        }
        
        if flashcards.count != 0 {
            var index = currentIndex;
            while(index == currentIndex){
            index = Int.random(in: 0 ..< flashcards.count)
            }
            currentIndex = index
            return flashcard(at: index!)
            
        }
       
            return nil
        
    }
    
    func flashcard(at index: Int) -> Flashcard?{
        if index >= 0 && index < flashcards.count {
           
            return flashcards[index]
        }
      
        return nil
        
    }
    
    func nextFlashcard() -> Flashcard?{
        if flashcards.count == 0 {return nil}
        
        if currentIndex == flashcards.count - 1{
            currentIndex = 0;
            return flashcard(at: currentIndex!)
        }
        else {
            currentIndex = currentIndex! + 1
            return flashcard(at: currentIndex!)
        }
    }
    func previousFlashcard() -> Flashcard?{
        if flashcards.count == 0 {return nil}
        
        if currentIndex == 0{
            currentIndex = flashcards.count - 1;
            return flashcard(at: currentIndex!)
        }
        else {
            currentIndex = currentIndex! - 1
            return flashcard(at: currentIndex!)
        }
    }
    
    // Inserts a flashcard – sets currentIndex appropriately when inserting to certain positions
//    func insert(question: String,
//                answer: String,
//                favorite: Bool){
//        let flashcard = Flashcard(question: question, answer: answer, isFavorite: favorite)
//        flashcards.append(flashcard)
//        currentIndex = flashcards.count-1
//    }
    
    
    func insert(question: String,
                answer: String,
                favorite: Bool,
    at index: Int){
        
        if(index > flashcards.count || index < 0) {
            return
        }
        
        let flashcard = Flashcard(question: question, answer: answer, isFavorite: favorite)
       
        flashcards.insert(flashcard, at: index)
        
        
        if index <= currentIndex ?? -1 {currentIndex = currentIndex! + 1}
        
        
        save()
    }
    // Returns the current flashcard at currentIndex
    func currentFlashcard() -> Flashcard?{
        if let currentIndex = currentIndex {
            return flashcard(at: currentIndex)
        }
        return nil
    }
    // Removes a flashcard – sets currentIndex appropriately when removing from certain positionss
    func removeFlashcard(at index: Int){
        if index >= 0 && index < flashcards.count {
            if(currentIndex! >= index && currentIndex != 0) {
                currentIndex = currentIndex! - 1
            }
            else if flashcards.count == 1{
                currentIndex = nil
                
            }
            flashcards.remove(at: index)
            
        }
        
        save()
    
    }
    // Favorite/unfavorite the current flashcard
    
    //Double check this!
    func toggleFavorite()
{
    if flashcards.count == 0 {return}
    
    let question = (currentFlashcard()?.getQuestion())!
    let answer = (currentFlashcard()?.getAnswer())!
    let inverseFavorite = !currentFlashcard()!.isFavorite
    removeFlashcard(at: currentIndex ?? 0)
    
    
    insert(question: question, answer: answer, favorite: inverseFavorite, at: currentIndex ?? 0)
}
    // Returns the favorite flashcards from your flashcards
    func favoriteFlashcards() -> [Flashcard]{
        var favorites: [Flashcard] = []
        for flashcard in flashcards{
            if flashcard.isFavorite == true {
                favorites.append(flashcard)
            }
        }
        return favorites
    }
    
    func rearrageFlashcards(from: Int, to: Int){
        let Flashcard = flashcard(at: from)
        
        guard let question = Flashcard?.getQuestion() else {return}
        guard let answer = Flashcard?.getAnswer() else {return}
        guard let favorite = Flashcard?.isFavorite else {return}
        
        removeFlashcard(at: from)
        insert(question: question, answer: answer, favorite: favorite, at: to)
    }
    
    func checkAskedQuestion(potentialQuestion: String) -> Bool
    {
        for flashcard in flashcards
        {
            let question = flashcard.getQuestion()
            if question.lowercased().contains(potentialQuestion.lowercased()) {return true}
        }
        return false
    }
    
    //Save the array of flashcards to a plist in the
    //Documents folder
    //Only called by methods in my FlashcardsModel
    //
    private func save() {
        //An array of dictionary objects where the key are Strings and the values are Strings
        var flashcardsArray = [[String:String]]()
        
        (flashcardsArray as NSArray).write(toFile: filepath, atomically: true)
        
        for flashcard in flashcards {
            let dict = ["questionKey": flashcard.getQuestion(), "answerKey": flashcard.getAnswer(), "favoriteKey": String(flashcard.isFavorite)]
            
            flashcardsArray.append(dict)
        }
        (flashcardsArray as NSArray).write(toFile: filepath, atomically: true)
    }
}
