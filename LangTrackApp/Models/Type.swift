//
//  Type.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-31.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

enum Type: Int,  Codable {
    case header = 0
    case likertScales = 1
    case fillInTheBlank = 2
    case multipleChoice = 3
    case singleMultipleAnswers = 4
    case openEndedTextResponses = 5
    case footer = 6
}
