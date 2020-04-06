//
//  Answer.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-02.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

class Answer : Codable{
    var type: String = ""
    var index: Int = -99
    var likertAnswer: Int? = nil
    var fillBlankAnswer: Int? = nil
    var multipleChoiceAnswer: [Int]? = nil
    var singleMultipleAnswer: Int? = nil
    var openEndedAnswer: String? = nil
    var timeDurationAnswer: DurationAnswer? = nil
    
    init(type: String,
        index: Int,
         likertAnswer: Int? = nil,
         fillBlankAnswer: Int? = nil,
         multipleChoiceAnswer: [Int]? = nil,
         singleMultipleAnswer: Int? = nil,
         openEndedAnswer: String? = nil,
         timeDurationAnswer: DurationAnswer? = nil) {
        self.type = type
        self.index = index
        self.likertAnswer = likertAnswer
        self.fillBlankAnswer = fillBlankAnswer
        self.multipleChoiceAnswer = multipleChoiceAnswer
        self.singleMultipleAnswer = singleMultipleAnswer
        self.openEndedAnswer = openEndedAnswer
        self.timeDurationAnswer = timeDurationAnswer
    }
    
    func isEmpty() -> Bool{
        if (likertAnswer == nil &&
            fillBlankAnswer == nil &&
            multipleChoiceAnswer == nil &&
            singleMultipleAnswer == nil &&
            openEndedAnswer == nil &&
            timeDurationAnswer == nil){
            return true
        }else {
            return false
        }
    }
}

class DurationAnswer: Codable{
    var hours: Int = 0
    var minutes: Int = 0
}
