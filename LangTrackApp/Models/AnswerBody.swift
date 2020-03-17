//
//  AnswerBody.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-17.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

struct AnswerBody: Codable{
    var index: Int = -99
    var type: String = ""
    var intValue: Int? = nil
    var multiValue: [Int]? = nil
    var stringValue: String? = nil
}
