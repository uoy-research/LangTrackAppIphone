//
//  Survey.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-31.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

class Survey : Codable{
    var id: String = ""
    var date: Int64 = 0
    var responded: Bool = false
    var title: String = ""
    var questions = [Question]()
}
