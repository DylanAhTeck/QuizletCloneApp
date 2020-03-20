//
//  AhTeckDylanHW5Tests.swift
//  AhTeckDylanHW5Tests
//
//  Created by Dylan  Ah Teck on 10/20/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import XCTest
@testable import AhTeckDylanHW5

class AhTeckDylanHW5Tests: XCTestCase {

    private var Model : FlashcardsModel?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Model = FlashcardsModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
 
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    //Test 1
    func testSharedModel() {
        let model1 = FlashcardsModel.shared
        let model2 = FlashcardsModel.shared
        // modify model1 and check if model2 has this modification
        
        model1.insert(question: "What is the Capital of France", answer: "Paris", favorite: true)
        XCTAssertEqual(model1.numberOfFlashcards(), model2.numberOfFlashcards())
    }
    
    //Test 2
    func testNumberOfFlashcards(){
        XCTAssertEqual(Model?.numberOfFlashcards(), 5)
    }
    
    //Test 3
    func testRandomFlashcard(){
        for _ in 0..<1000 {
            let currAnswer = Model?.currentFlashcard()?.getAnswer()
            XCTAssertNotEqual(Model?.randomFlashcard()?.getAnswer(), currAnswer)
        }
    }
    
    //Test 4
    func testFlashcard(){
        XCTAssertEqual(Model?.flashcard(at:4)?.getQuestion(),"What is the Capital of Singapore?")
        XCTAssertEqual(Model?.flashcard(at:-1)?.getQuestion(), nil)
        XCTAssertEqual(Model?.flashcard(at: 10)?.getQuestion(), nil)
    }
    
    //Test 5
    func testNextFlashcard(){
        //Starts with "What is the Capital of Mauritius as initial question"
        XCTAssertEqual(Model?.nextFlashcard()?.getQuestion(),"What is the Capital of Australia?")
        XCTAssertEqual(Model?.nextFlashcard()?.getQuestion(),"What is the Capital of England?")
        XCTAssertEqual(Model?.nextFlashcard()?.getQuestion(),"What is the Capital of South Africa?")
        XCTAssertEqual(Model?.nextFlashcard()?.getQuestion(),"What is the Capital of Singapore?")
        XCTAssertEqual(Model?.nextFlashcard()?.getQuestion(),"What is the Capital of Mauritius?")
        
    }
    
    //Test 6
    func testPreviousFlashcard(){
        //Starts with "Port Louis" as initial answer
        XCTAssertEqual(Model?.previousFlashcard()?.getAnswer(),"Singapore")
        XCTAssertEqual(Model?.previousFlashcard()?.getAnswer(),"Johannesburg")
        XCTAssertEqual(Model?.previousFlashcard()?.getAnswer(),"London")
        XCTAssertEqual(Model?.previousFlashcard()?.getAnswer(),"Canberra")
        XCTAssertEqual(Model?.previousFlashcard()?.getAnswer(),"Port Louis")
    }
    
    //Test 7 - insert at end
    func testInsert1(){
        Model?.insert(question: "What is the Capital of the US?", answer:
            "Washington DC", favorite: true)
        XCTAssertEqual(Model?.flashcard(at: 5)?.getQuestion(),"What is the Capital of the US?")
        XCTAssertEqual(Model?.flashcard(at: 5)?.getAnswer(),"Washington DC")
    }
    
    //Test 8 - insert at specific index
    func testInsert2(){
        Model?.insert(question: "What is the Capital of the US?", answer:
            "Washington DC", favorite: true, at: 3)
        XCTAssertEqual(Model?.flashcard(at: 3)?.getQuestion(),"What is the Capital of the US?")
        XCTAssertEqual(Model?.flashcard(at: 3)?.getAnswer(),"Washington DC")
    }
    
    //Test 9
    func testCurrentFlashcard() {
        XCTAssertEqual(Model?.currentFlashcard()?.getQuestion() , Model?.flashcard(at: 0)?.getQuestion())
    }
    
    //Test 10
    func testRemove(){
  
        //Out of bounds does not crash app
        Model?.removeFlashcard(at: -1)
        Model?.removeFlashcard(at: 10)
        
      
        Model?.removeFlashcard(at: 0)
        
        //Gets moved from index 1 to 0
        XCTAssertEqual(Model?.flashcard(at: 0)?.getQuestion(), "What is the Capital of Australia?")
        
        Model?.removeFlashcard(at: 4)
        
        //Removed 4th element
        XCTAssertEqual(Model?.flashcard(at: 4)?.isFavorite, nil)
    }
    
    //Test 11
        func testToggleFavorite(){
            
            let favorite = Model?.currentFlashcard()?.isFavorite
            
            Model?.toggleFavorite()
            
            //Current flashcard favorite should be different
            XCTAssertNotEqual(Model?.currentFlashcard()?.isFavorite, favorite)
       
        }
    
    //Test 12
    func testFavoriteFlashcards(){
        
        //Only 4th and 5th flashguard has favorite bool set during init
        //favoriteFlashcards() should only return those cards
        guard let flashcard4 = Model?.flashcard(at: 3) else { return }
        guard let flashcard5 = Model?.flashcard(at: 4) else { return }
        
        
        XCTAssertEqual(Model?.favoriteFlashcards(), [flashcard4, flashcard5])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
