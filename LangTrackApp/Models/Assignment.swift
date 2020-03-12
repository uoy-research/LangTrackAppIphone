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
    var updatedAt : Date?
    var createdAt : Date?
    var userId = ""
    var dataset: Dataset? = nil
    var published : Date?
    var expiry : Date?
    
    func timeLeftToExpiryInMilli() -> Int64?{
        if published != nil && expiry != nil{
            let millisecondsLeft = expiry!.millisecondsSince1970 - Date().millisecondsSince1970
            if millisecondsLeft <= 0{
                return 0
            }else{
                return millisecondsLeft
            }
        }
        return nil
    }
}
