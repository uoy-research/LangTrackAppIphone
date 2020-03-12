//
//  Dataset.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-11.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation
class Dataset: Codable {
    
    var createdAt = ""
    var updatedAt = ""
    var answers = [Answer]()
}
