//
//  Assignment.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-11.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

struct Assignment: Codable {
    var survey = Survey()
    var updatedAt = ""
    var createdAt = ""
    var userId = ""
    var dataset: Dataset? = nil
    var published = ""
    var expiry = ""
    
    func timeLeftToExpiryInMilli() -> Int64{
        let now = Date()
        let exp = DateParser.getDate(dateString: expiry) ?? now
        let millisecondsLeft = exp.millisecondsSince1970 - now.millisecondsSince1970
        if millisecondsLeft <= 0{
            return 0
        }else{
            return millisecondsLeft
        }
    }
}
