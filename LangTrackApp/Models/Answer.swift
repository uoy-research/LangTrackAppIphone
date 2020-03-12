//
//  Answer.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-02.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

class Answer : Codable{
    var index: Int = -99
    var likertAnswer: Int? = nil
    var fillBlankAnswer: Int? = nil
    var multipleChoiceAnswer: [Int]? = nil
    var singleMultipleAnswer: Int? = nil
    var openEndedAnswer: String? = nil
    
    init(index: Int,
         likertAnswer: Int? = nil,
         fillBlankAnswer: Int? = nil,
         multipleChoiceAnswer: [Int]? = nil,
         singleMultipleAnswer: Int? = nil,
         openEndedAnswer: String? = nil) {
        self.index = index
        self.likertAnswer = likertAnswer
        self.fillBlankAnswer = fillBlankAnswer
        self.multipleChoiceAnswer = multipleChoiceAnswer
        self.singleMultipleAnswer = singleMultipleAnswer
        self.openEndedAnswer = openEndedAnswer
    }
    
    func isEmpty() -> Bool{
        if (likertAnswer == nil &&
            fillBlankAnswer == nil &&
            multipleChoiceAnswer == nil &&
            singleMultipleAnswer == nil &&
            openEndedAnswer == nil){
            return true
        }else {
            return false
        }
    }
}
