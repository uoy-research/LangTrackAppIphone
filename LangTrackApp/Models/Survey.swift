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
    var title: String = ""
    var questions = [Question]()
    var respondeddate: Date?
    var published: Date?
    var expiry: Date?
    var answer = [Int:Answer]()
    var updatedAt = ""
    var createdAt = ""
}
