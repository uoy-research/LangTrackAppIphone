//
//  Survey.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-31.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

struct Survey : Codable{
    var id: String = ""//TODO: remove
    var name: String = ""
    var title: String = ""
    var questions = [Question]()
    var respondeddate: String = ""
    var published: String = ""
    var expiry: String = ""
    var answer = [Int:Answer]()
    var updatedAt = ""
    var createdAt = ""
}
