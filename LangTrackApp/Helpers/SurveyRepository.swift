//
//  SurveyRepository.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-02-05.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation
import SwiftyJSON


struct SurveyRepository {
    
    //sista nollan ska ändras till etta vid hämtning från dropbox
    //static let theUrl = "https://www.dropbox.com/s/qmvskzi4ejtg5ij/play_survey_json.txt?dl=1"
    static let mockUrl = "https://e3777de6-509b-46a9-a996-ea2708cc0192.mock.pstmn.io/"
    
    static var idToken = ""
    static var localTimeZoneIdentifier = ""
    static var assignmentList: [Assignment] = []
    static var selectedAssignment: Assignment?
    static let tempuserId = "u123"
    
    static func setIdToken(token: String){
        self.idToken = token
    }
    
    static func postAnswer(answerDict: [Int: Answer]){
        
        var answers = [AnswerBody]()
        for answer in answerDict.values{
            var body = AnswerBody()
            body.index = answer.index
            body.type = answer.type
            switch answer.type {
            case "likert":
                body.intValue = answer.likertAnswer
            case "single":
                body.intValue = answer.singleMultipleAnswer
            case "blanks":
                body.intValue = answer.fillBlankAnswer
            case "multi":
                body.multiValue = answer.multipleChoiceAnswer
            case "open":
                body.stringValue = answer.openEndedAnswer
            default:
                print("answersDict, no match in switch")
            }
            if body.index != -99{
                answers.append(body)
            }
        }
        let theBody = ["answers": answers]
        let encoder = JSONEncoder()
        if selectedAssignment?.id ?? "" != ""{
            if let bodyData = try? encoder.encode(theBody) {
                if let jsonString = String(data: bodyData, encoding: .utf8) {
                    print(jsonString)
                }
                // POST '/assignments/[assignmentID: _id]/datasets'
                let answerUrl = "\(mockUrl)assignments/\(selectedAssignment!.id)/datasets"
                let request = NSMutableURLRequest(url: URL(string: answerUrl)!)
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue(idToken, forHTTPHeaderField: "token")
                /*do {
                 request.httpBody = try JSONSerialization.data(withJSONObject: bodyData, options: .prettyPrinted)
                 } catch let error {
                 print(error.localizedDescription)
                 }*/
                request.httpBody = bodyData
                
                let session = URLSession.shared
                request.httpMethod = "POST"
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                    if(error != nil){
                        print("ERROR, task = session.dataTask: \(error!.localizedDescription)")
                        return
                    }else{
                        print("postAnswer response: \(response.debugDescription)")
                    }
                })
                task.resume()
            }
        }
    }
    
    static func surveyOpened(timeInUtc: String){
        
        let param = [
            "openedAt": timeInUtc
        ]
        if selectedAssignment != nil{
            if selectedAssignment!.id != ""{
                let deviceTokenUrl = "\(mockUrl)assignments/\(selectedAssignment!.id)/opened"//TODO: set correct url
                let request = NSMutableURLRequest(url: URL(string: deviceTokenUrl)!)
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue(idToken, forHTTPHeaderField: "token")
                
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                }
                
                let session = URLSession.shared
                request.httpMethod = "PUT"
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                /**
                 the params are json, please check with the server if it requires form data then change the content type e.g. request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type"*/
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                    if(error != nil){
                        print("ERROR, task = session.dataTask: \(error!.localizedDescription)")
                        return
                    }else{
                        if let httpResponse = response as? HTTPURLResponse {
                            print("postAnswer response statusCode: \(httpResponse.statusCode)")
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    static func postDeviceToken(deviceToken: String){
    
        /*
         /users/u123
         
         {
             "timezone": "Europe/Stockholm",
             "deviceToken": "qwerty12345qwert23456"
         }
         */
        let param = [
            "timezone": localTimeZoneIdentifier,
            "deviceToken": deviceToken
        ]
        
        let deviceTokenUrl = "\(mockUrl)user/\(tempuserId)"
        let request = NSMutableURLRequest(url: URL(string: deviceTokenUrl)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(idToken, forHTTPHeaderField: "token")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        request.httpMethod = "PUT"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        /**
         the params are json, please check with the server if it requires form data then change the content type e.g. request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type"*/
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                print("ERROR, task = session.dataTask: \(error!.localizedDescription)")
                return
            }else{
                if let httpResponse = response as? HTTPURLResponse {
                    print("postAnswer response statusCode: \(httpResponse.statusCode)")
                }
            }
        })
        task.resume()
        
    }
    
    static func getSurveys( completionhandler: @escaping (_ result: [Assignment]?) -> Void){
        
        let assignmentsTokenUrl = "\(mockUrl)user/\(tempuserId)/assignments"
        let request = NSMutableURLRequest(url: URL(string: assignmentsTokenUrl)!)
        
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(idToken, forHTTPHeaderField: "token")

        let session = URLSession.shared
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData//to refresh...
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                print("ERROR, task = session.dataTask: \(error!.localizedDescription)")
                completionhandler(nil)
                return
            }
            /*do {
                // Read all HTTP Response Headers
                if let response = response as? HTTPURLResponse {
                    print("All headers: \(response.allHeaderFields)")
                    // Read a specific HTTP Response Header by name
             print("Specific header: \(response.value(forHTTPHeaderField: "Content-Type") ?? " header not found")")
             }
             }*/
            if data != nil{
                let listWithAssignments = createAssignmentsFromData(data: data!)
                if listWithAssignments != nil{
                    for assignment in listWithAssignments!{
                        for question in assignment.survey.questions{
                            if question.index == 0{
                                question.previous = 0
                                question.next = question.index + 1
                            }else if question.index < assignment.survey.questions.count - 1{
                                question.next = question.index + 1
                                question.previous = question.index - 1
                            }else{
                                question.next = 0
                                question.previous = question.index - 1
                            }
                        }
                    }
                }
                assignmentList = listWithAssignments!
            }
            
            completionhandler(assignmentList)
        })
        task.resume()
    }
    
    static func sortAssignmentList(theList : [Assignment]) -> [Assignment]{
        let now = Date()
        //if the assignment is active and the dataset is empty
        var activeList = theList.filter {$0.dataset == nil && DateParser.getDate(dateString: $0.expiry) ?? now > now}
        //if the assignment is not active or the dataset exists
        var unActiveList = theList.filter {$0.dataset != nil || DateParser.getDate(dateString: $0.expiry) ?? now < now}
        activeList.sort {DateParser.getDate(dateString: $0.survey.published) ?? Date() < DateParser.getDate(dateString: $1.survey.published) ?? Date()}
        unActiveList.sort {DateParser.getDate(dateString: $0.survey.published) ?? Date() < DateParser.getDate(dateString: $1.survey.published) ?? Date()}
        var finallist = [Assignment]()
        finallist.append(contentsOf: activeList)
        finallist.append(contentsOf: unActiveList)
        
        return finallist
    }
    
    private static func createAssignmentsFromData(data: Data) -> [Assignment]?{
        var returnValue = [Assignment]()
        do {
            let json = try JSON(data: data)
            for (_,assignmentJson):(String, JSON) in json {
                var tempAssignment = Assignment()
                for (key,postJson):(String, JSON) in assignmentJson{
                    if key == "_id"{
                        tempAssignment.id = postJson.stringValue
                    }
                    if key == "userId"{
                        tempAssignment.userId = postJson.stringValue
                    }
                    if key == "createdAt"{
                        tempAssignment.createdAt = postJson.stringValue
                    }
                    if key == "updatedAt"{
                        tempAssignment.updatedAt = postJson.stringValue
                    }
                    if key == "expireAt"{
                        tempAssignment.expiry = postJson.stringValue
                    }
                    if key == "publishAt"{
                        tempAssignment.published = postJson.stringValue
                    }
                    if key == "survey"{
                        if let surveyDict = postJson.dictionaryObject{
                            
                            if let updatedAt = surveyDict["updatedAt"] as? String{
                                tempAssignment.survey.updatedAt = updatedAt
                            }
                            if let createdAt = surveyDict["createdAt"] as? String{
                                tempAssignment.survey.createdAt = createdAt
                            }
                            if let id = surveyDict["name"] as? String{
                                tempAssignment.survey.name = id
                            }
                            if let id = surveyDict["id"] as? String{//TODO: remove
                                tempAssignment.survey.id = id
                            }
                            if let title = surveyDict["title"] as? String{
                                tempAssignment.survey.title = title
                            }
                            if let published = surveyDict["publishAt"] as? String{
                                tempAssignment.survey.published = published
                            }
                            if let expiry = surveyDict["expireAt"] as? String{
                                tempAssignment.survey.expiry = expiry
                            }
                            if let questionsDict = surveyDict["questions"] as? [Any]{
                                for question in questionsDict{
                                    let tempQuestion = Question()
                                    var values: [String]?
                                    if let post = question as? [String: Any]{
                                        
                                        var index = -99
                                        var type = ""
                                        var description = ""
                                        var title = ""
                                        var text = ""
                                        for questionPost in post{
                                            if questionPost.key == "index"{
                                                index = questionPost.value as? Int ?? -99
                                            }
                                            if questionPost.key == "type"{
                                                type = questionPost.value as? String ?? ""
                                            }
                                            if questionPost.key == "description"{
                                                description = questionPost.value as? String ?? ""
                                            }
                                            if questionPost.key == "title"{
                                                title = questionPost.value as? String ?? ""
                                            }
                                            if questionPost.key == "text"{
                                                text = questionPost.value as? String ?? ""
                                            }
                                            if questionPost.key == "values"{
                                                if let valuesArray = questionPost.value as? [String]{
                                                    values = valuesArray
                                                }
                                            }
                                            if questionPost.key == "skip"{
                                                if let skipDict = questionPost.value as? [String:Int]{
                                                    let tempSkip = SkipLogic()
                                                    for i in skipDict{
                                                        if i.key == "goto"{
                                                            tempSkip.goto = i.value
                                                        }
                                                        if i.key == "ifChosen"{
                                                            tempSkip.ifChosen = i.value
                                                        }
                                                    }
                                                    tempQuestion.skip = tempSkip
                                                }
                                            }
                                        }
                                        tempQuestion.index = index
                                        tempQuestion.type = type
                                        tempQuestion.description = description
                                        tempQuestion.title = title
                                        tempQuestion.text = text
                                    }
                                    if values != nil{
                                        switch tempQuestion.type {
                                        case "single":
                                            tempQuestion.singleMultipleAnswers = values
                                        case "multi":
                                            tempQuestion.multipleChoisesAnswers = values
                                        case "blanks":
                                            tempQuestion.fillBlanksChoises = values
                                        default:
                                            1 == 1//not using default...
                                        }
                                    }
                                    tempAssignment.survey.questions.append(tempQuestion)
                                }
                            }
                        }
                    }
                    if key == "dataset"{
                        let setDict = postJson.dictionaryObject
                        let tempDataSet : Dataset?
                        if setDict != nil{
                            tempDataSet = Dataset()
                            
                            if let updatedAt = setDict!["updatedAt"] as? String{
                                tempDataSet!.updatedAt = updatedAt
                            }
                            if let createdAt = setDict!["createdAt"] as? String{
                                tempDataSet!.createdAt = createdAt
                            }
                            let answersDict = setDict!["answers"] as? [Any]
                            if answersDict != nil{
                                var tempAnswers = [Answer]()
                                for post in answersDict!{
                                    if let answer = post as? [String: Any]{
                                        var index = 0
                                        var type = ""
                                        var multiValue: [Int]?
                                        var intValue: Int?
                                        var stringValue: String?
                                        for answerPost in answer{
                                            if answerPost.key == "index"{
                                                index = answerPost.value as? Int ?? 0
                                            }
                                            if answerPost.key == "type"{
                                                type = answerPost.value as? String ?? ""
                                            }
                                            if answerPost.key == "multiValue"{
                                                multiValue = answerPost.value as? [Int]
                                            }
                                            if answerPost.key == "intValue"{
                                                intValue = answerPost.value as? Int
                                            }
                                            if answerPost.key == "stringValue"{
                                                stringValue = answerPost.value as? String
                                            }
                                        }
                                        switch type {
                                        case "likert":
                                            tempAnswers.append(Answer(type: "likert",index: index, likertAnswer: intValue, fillBlankAnswer: nil, multipleChoiceAnswer: nil, singleMultipleAnswer: nil, openEndedAnswer: nil))
                                        case "single":
                                            tempAnswers.append(Answer(type: "single",index: index, likertAnswer: nil, fillBlankAnswer: nil, multipleChoiceAnswer: nil, singleMultipleAnswer: intValue, openEndedAnswer: nil))
                                        case "multi":
                                            tempAnswers.append(Answer(type: "multi",index: index, likertAnswer: nil, fillBlankAnswer: nil, multipleChoiceAnswer: multiValue, singleMultipleAnswer: nil, openEndedAnswer: nil))
                                        case "blanks":
                                            tempAnswers.append(Answer(type: "blanks",index: index, likertAnswer: nil, fillBlankAnswer: intValue, multipleChoiceAnswer: nil, singleMultipleAnswer: nil, openEndedAnswer: nil))
                                        case "open":
                                            tempAnswers.append(Answer(type: "open",index: index, likertAnswer: nil, fillBlankAnswer: nil, multipleChoiceAnswer: nil, singleMultipleAnswer: nil, openEndedAnswer: stringValue))
                                        default:
                                            print("answersDict, no match in switch")
                                        }
                                    }
                                }
                                tempDataSet!.answers = tempAnswers
                            }
                            if tempDataSet != nil{
                                tempAssignment.dataset = tempDataSet
                            }
                        }
                    }
                }
                tempAssignment.survey.questions.sort(by: { $0.index < $1.index})
                returnValue.append(tempAssignment)
            }
        }catch  {
            print("no json")
        }
        if returnValue.count > 0{
            returnValue = sortAssignmentList(theList: returnValue)
            return returnValue
        }else{
            return nil
        }
    }
}
