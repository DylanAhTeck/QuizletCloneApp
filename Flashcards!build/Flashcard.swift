//
//  Flashcard.swift
//  AhTeckDylanHW5
//
//  Created by Dylan  Ah Teck on 10/20/19.
//  Copyright © 2019 Dylan  Ah Teck. All rights reserved.
//

import Foundation

struct Flashcard:Equatable {
    
    var question: String
    var answer: String
    var isFavorite: Bool
    
    func getQuestion() -> String {
        return question
    }
    
    func getAnswer() -> String {
        return answer
    }
    
    init(question: String, answer: String, isFavorite: Bool = false) {
        self.question = question
        self.answer = answer
        self.isFavorite = isFavorite
    }
}
