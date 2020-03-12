//
//  Assignment.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-11.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

class Assignment {
    var survey = Survey()
    var updatedAt = ""
    var createdAt = ""
    var userId = ""
    var dataset: Dataset? = nil
    var published = ""
    var expiry = ""
    /*
     [
         {
             "_id": "5e67ad3167b21b72c4757818",
             "survey": {
                 "_id": "5e67ad0d67b21b72c4757812",
                 "questions": [
                     {
                         "values": [
                             "Ja",
                             "Nej"
                         ],
                         "_id": "5e67ad0d67b21b72c4757813",
                         "index": 0,
                         "text": "Har du pratat med nån?",
                         "type": "single"
                     },
                     {
                         "values": [
                             "a",
                             "b",
                             "c"
                         ],
                         "_id": "5e67ad0d67b21b72c4757814",
                         "index": 1,
                         "text": "Vad pratade ni om?",
                         "type": "multi"
                     },
                     {
                         "values": [],
                         "_id": "5e67ad0d67b21b72c4757815",
                         "index": 2,
                         "text": "Hur gick det?",
                         "type": "likert"
                     },
                     {
                         "values": [
                             "normalt",
                             "utmanande",
                             "enkelt",
                             "givande"
                         ],
                         "_id": "5e67ad0d67b21b72c4757816",
                         "index": 3,
                         "text": "Samtalet kändes _____.",
                         "type": "blanks"
                     },
                     {
                         "values": [],
                         "_id": "5e67ad0d67b21b72c4757817",
                         "index": 4,
                         "text": "Övrig kommentar?",
                         "type": "open"
                     }
                 ],
                 "title": "tisdag",
                 "id": "s2",
                 "createdAt": "2020-03-10T15:06:53.617Z",
                 "updatedAt": "2020-03-10T15:07:29.278Z",
                 "__v": 0
             },
             "userId": "u123",
             "createdAt": "2020-03-10T15:07:29.278Z",
             "updatedAt": "2020-03-10T15:11:52.353Z",
             "__v": 0,
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
         },
         {
             "_id": "5e67adf467b21b72c4757822",
             "survey": {
                 "_id": "5e67ade467b21b72c4757820",
                 "questions": [
                     {
                         "values": [
                             "Ja",
                             "Nej"
                         ],
                         "_id": "5e67ade467b21b72c4757821",
                         "index": 0,
                         "text": "Har du pratat med nån idag?",
                         "type": "single"
                     }
                 ],
                 "title": "tisdag",
                 "id": "s1",
                 "createdAt": "2020-03-10T15:10:28.677Z",
                 "updatedAt": "2020-03-10T15:10:44.356Z",
                 "__v": 0
             },
             "userId": "u123",
             "createdAt": "2020-03-10T15:10:44.356Z",
             "updatedAt": "2020-03-10T15:10:44.356Z",
             "__v": 0
         }
     ]
     ¨*/
}
