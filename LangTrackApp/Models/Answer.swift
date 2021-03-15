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
    var timeDurationAnswer: Int? = nil // in seconds
    var sliderScaleAnswer: Int? = nil
    
    init(type: String,
        index: Int,
         likertAnswer: Int? = nil,
         fillBlankAnswer: Int? = nil,
         multipleChoiceAnswer: [Int]? = nil,
         singleMultipleAnswer: Int? = nil,
         openEndedAnswer: String? = nil,
         timeDurationAnswer: Int? = nil,
         sliderScaleAnswer: Int? = nil) {
        self.type = type
        self.index = index
        self.likertAnswer = likertAnswer
        self.fillBlankAnswer = fillBlankAnswer
        self.multipleChoiceAnswer = multipleChoiceAnswer
        self.singleMultipleAnswer = singleMultipleAnswer
        self.openEndedAnswer = openEndedAnswer
        self.timeDurationAnswer = timeDurationAnswer
        self.sliderScaleAnswer = sliderScaleAnswer
    }
    
    func isEmpty() -> Bool{
        if (likertAnswer == nil &&
                fillBlankAnswer == nil &&
                multipleChoiceAnswer == nil &&
                singleMultipleAnswer == nil &&
                openEndedAnswer == nil &&
                timeDurationAnswer == nil &&
                sliderScaleAnswer == nil){
            return true
        }else {
            return false
        }
    }
}
