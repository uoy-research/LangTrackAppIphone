//
//  Dataset.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-11.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation
class Dataset {
    
    var createdAt = ""
    var updatedAt = ""
    var answers = [Answer]()
}
/*
 "dataset": {
     "_id": "5e67ae3867b21b72c4757829",
     "answers": [
         {
             "multiValue": [],
             "_id": "5e67ae3867b21b72c475782a",
             "index": 0,
             "type": "single",
             "intValue": 1
         },
         {
             "multiValue": [
                 1,
                 2
             ],
             "_id": "5e67ae3867b21b72c475782b",
             "index": 1,
             "type": "multi"
         },
         {
             "multiValue": [],
             "_id": "5e67ae3867b21b72c475782c",
             "index": 2,
             "type": "likert",
             "stringValue": "10"
         },
         {
             "multiValue": [],
             "_id": "5e67ae3867b21b72c475782d",
             "index": 4,
             "type": "blanks",
             "intValue": 3
         },
         {
             "multiValue": [],
             "_id": "5e67ae3867b21b72c475782e",
             "index": 4,
             "type": "open",
             "stringValue": "Kul!"
         }
     ],
     "updatedAt": "2020-03-10T15:11:52.353Z",
     "createdAt": "2020-03-10T15:11:52.353Z"
 }
 */
