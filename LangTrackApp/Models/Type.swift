//
//  Type.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-31.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

enum Type: String,  Codable {
    case header = "header"
    case likertScales = "likert"
    case fillInTheBlank = "blanks"
    case multipleChoice = "multi"
    case singleMultipleAnswers = "single"
    case openEndedTextResponses = "open"
    case timeDuration = "duration"
    case sliderScale = "slider"
    case footer = "footer"
}
