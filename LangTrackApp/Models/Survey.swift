//
//  Survey.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-31.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

struct Survey : Codable{
    var id: String = ""
    var date: Int64 = -1
    var title: String = ""
    var questions = [Question]()
    var respondeddate: Int64? = -1
    var published: Int64? = -1
    var expiry: Int64? = -1
    var answer = [Int:Answer]()
    
    func answerIsEmpty() -> Bool{
        for i in answer{
            if !i.value.isEmpty(){
                return false
            }
        }
        return true
    }
    
    func isActive() -> Bool{
        var isActive = false
        let currentMilli = Date().millisecondsSince1970
        //check time to see if survey is inactive even if answer is nil
        if self.expiry != nil{
            if (self.expiry! > currentMilli &&
                self.answerIsEmpty()){
                isActive = true
            }
        }
        return isActive
    }
}
