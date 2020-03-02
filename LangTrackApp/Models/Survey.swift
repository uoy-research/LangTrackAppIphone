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
    var responded: Bool? = false
    var title: String = ""
    var questions = [Question]()
    var active: Bool? = false
    var respondeddate: Int64? = -1
    var published: Int64? = -1
    var expiry: Int64? = -1
    var answer = [Int:Answer]()
}
