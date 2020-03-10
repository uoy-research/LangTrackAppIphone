//
//  JsonHelper.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-02-05.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation
import SwiftyJSON


struct SurveyRepository {
    
    //sista nollan ska ändras till etta vid hämtning från dropbox
    static let theUrl = "https://www.dropbox.com/s/d6ligny9b1lmlqj/play_survey_json.txt?dl=1"
    static var idToken = ""
    
    static func setIdToken(token: String){
        self.idToken = token
    }
    
    static func postDeviceToken(deviceToken: String){
        let parameters = ["deviceToken": deviceToken]
        let deviceTokenUrl = "\(theUrl)/u123/devicetoken"
        let request = NSMutableURLRequest(url: URL(string: deviceTokenUrl)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(idToken, forHTTPHeaderField: "token")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        /**
         the params are json, please check with the server if it requires form data then change the content type e.g. request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type"*/
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                print("ERROR, task = session.dataTask: \(error!.localizedDescription)")
                return
            }
        })
        task.resume()
        
    }
    
    static func getSurveys( completionhandler: @escaping (_ result: [Survey]?) -> Void){
        
        let request = NSMutableURLRequest(url: URL(string: theUrl)!)
        
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(idToken, forHTTPHeaderField: "token")

        let session = URLSession.shared
        request.httpMethod = "GET"
        
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
            let listWithSurveys = parseJson(data: data!)
            if listWithSurveys != nil
            {
                for survey in listWithSurveys!{
                    for question in survey.questions{
                        if question.index == 0{
                            question.previous = 0
                            question.next = question.index + 1
                        }else if question.index < survey.questions.count - 1{
                            question.next = question.index + 1
                            question.previous = question.index - 1
                        }else{
                            question.next = 0
                            question.previous = question.index - 1
                        }
                    }
                }
            }
            
            //let answered = listWithSurveys?.filter($0 < 1)
            completionhandler(listWithSurveys)
        })
        task.resume()
    }
    
    
    private static func parseJson(data: Data) -> [Survey]?{
        var returnValue = [Survey]()
        
        do {
            let json = try JSON(data: data)
            for (_,subJson):(String, JSON) in json {
                var tempSurvey = Survey()
                for (key,subJson):(String, JSON) in subJson {
                    if(key == "title"){
                        tempSurvey.title = subJson.stringValue
                    }
                    if(key == "date"){
                        tempSurvey.date = subJson.int64Value
                    }
                    if(key == "expiry"){
                        tempSurvey.expiry = subJson.int64Value
                    }
                    if(key == "id"){
                        tempSurvey.id = subJson.stringValue
                    }
                    if(key == "published"){
                        tempSurvey.published = subJson.int64Value
                    }
                    if(key == "respondeddate"){
                        tempSurvey.respondeddate = subJson.int64Value
                    }
                    if(key == "questions"){
                        tempSurvey.questions = getQuestionsFrom(jsonArray: subJson)
                    }
                    if(key == "answers"){
                        let answerDict = subJson.arrayObject
                        if answerDict != nil{
                            var index = -99
                            var type = ""
                            var intValue = -99
                            var stringValue = ""
                            var multiValue: [Int] = []
                            for b in answerDict!{
                                let oneAnswer = b as? NSDictionary
                                if oneAnswer != nil{
                                    index = -99
                                    type = ""
                                    intValue = -99
                                    stringValue = ""
                                    multiValue = []
                                    for c in oneAnswer!{
                                        if c.key as! String == "index"{
                                            index = c.value as! Int
                                        }
                                        if c.key as! String == "type"{
                                            type = c.value as! String
                                        }
                                        if c.key as! String == "intValue"{
                                            intValue = c.value as! Int
                                        }
                                        if c.key as! String == "multiValue"{
                                            multiValue = c.value as! [Int]
                                        }
                                        if c.key as! String == "stringValue"{
                                            stringValue = c.value as! String
                                        }
                                    }
                                }
                            switch type {
                            case "likert":
                                if index != -99{
                                    tempSurvey.answer[index] = Answer(likertAnswer: intValue, fillBlankAnswer: nil, multipleChoiceAnswer: nil, singleMultipleAnswer: nil, openEndedAnswer: nil)
                                }
                            case "blanks":
                                if index != -99{
                                    tempSurvey.answer[index] = Answer(likertAnswer: nil, fillBlankAnswer: intValue, multipleChoiceAnswer: nil, singleMultipleAnswer: nil, openEndedAnswer: nil)
                                }
                            case "multi":
                                if index != -99{
                                    tempSurvey.answer[index] = Answer(likertAnswer: nil, fillBlankAnswer: nil, multipleChoiceAnswer: multiValue, singleMultipleAnswer: nil, openEndedAnswer: nil)
                                }
                            case "single":
                                if index != -99{
                                    tempSurvey.answer[index] = Answer(likertAnswer: nil, fillBlankAnswer: nil, multipleChoiceAnswer: nil, singleMultipleAnswer: intValue, openEndedAnswer: nil)
                                }
                            case "open":
                                if index != -99{
                                    tempSurvey.answer[index] = Answer(likertAnswer: nil, fillBlankAnswer: nil, multipleChoiceAnswer: nil, singleMultipleAnswer: nil, openEndedAnswer: stringValue)
                                }
                            default:
                                print("answer: no match")
                            }
                            }
                        }
                    }
                }
                returnValue.append(tempSurvey)
            }
        } catch  {
            print("no json")
        }
        
        
        // Decode data to object
        /*do {
         returnValue = try JSONDecoder().decode([Survey].self, from: data)
         } catch {
         print("data: \(data)")
         print("Error took place\(error.localizedDescription).")
         }*/
        return returnValue
    }
    
    static func getQuestionsFrom( jsonArray: JSON?) -> [Question]{
        var tempQuestions = [Question]()
        if jsonArray != nil{
            for (_,subJson):(String, JSON) in jsonArray!  {
                let tempQuestion = Question()
                var values: [String] = []
                for (key,subsubJson):(String, JSON) in subJson {
                    
                    if(key == "description"){
                        tempQuestion.description = subsubJson.stringValue
                    }
                    if(key == "text"){
                        tempQuestion.text = subsubJson.stringValue
                    }
                    if(key == "id"){
                        tempQuestion.id = subsubJson.stringValue
                    }
                    if(key == "index"){
                        tempQuestion.index = subsubJson.intValue
                    }
                    if(key == "title"){
                        tempQuestion.title = subsubJson.stringValue
                    }
                    if(key == "type"){
                        tempQuestion.type = subsubJson.stringValue
                    }
                    if(key == "values"){
                        let tempArray = subsubJson.arrayObject as? [String]
                        if tempArray != nil{
                            values.append(contentsOf: tempArray!)
                        }
                    }
                    if(key == "skip"){
                        let tempSkip = SkipLogic()
                        for (skipKey,skipJson):(String, JSON) in subsubJson {
                            if(skipKey == "goto"){
                                tempSkip.goto = skipJson.intValue
                            }
                            if(skipKey == "ifChosen"){
                                tempSkip.ifChosen = skipJson.intValue
                            }
                        }
                        if tempSkip.ifChosen != -99{
                            tempQuestion.skip = tempSkip
                        }
                    }
                }
                if values.count > 0{
                    switch tempQuestion.type {
                    case Type.multipleChoice.rawValue:
                        tempQuestion.multipleChoisesAnswers = values
                    case Type.singleMultipleAnswers.rawValue:
                        tempQuestion.singleMultipleAnswers = values
                    case Type.fillInTheBlank.rawValue:
                        tempQuestion.fillBlanksChoises = values
                    default:
                        print("tempQuestion.type: \(tempQuestion.type)")
                    }
                }
                tempQuestions.append(tempQuestion)
            }
        }
        return tempQuestions
    }
}
