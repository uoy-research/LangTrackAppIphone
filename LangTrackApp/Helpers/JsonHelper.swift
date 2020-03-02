//
//  JsonHelper.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-02-05.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation
import SwiftyJSON


struct JsonHelper {
    
    //sista nollan ska ändras till etta vid hämtning från dropbox
    static let theUrl = "https://www.dropbox.com/s/eqtummlm9fu4n8x/survey_json.txt?dl=1"
    
    static func getSurveys(token: String, completionhandler: @escaping (_ result: [Survey]?) -> Void){
        
        let request = NSMutableURLRequest(url: URL(string: theUrl)!)
        
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField: "token")

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
                    if(key == "active"){
                        tempSurvey.active = subJson.boolValue
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
                    if(key == "responded"){
                        tempSurvey.responded = subJson.boolValue
                    }
                    if(key == "respondeddate"){
                        tempSurvey.respondeddate = subJson.int64Value
                    }
                    if(key == "questions"){
                        tempSurvey.questions = getQuestionsFrom(jsonArray: subJson)
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
                    if(key == "fillBlanksChoises"){
                        var tempArray = [String]()
                        for (_,fillBlanksChoisesJson):(String, JSON) in subsubJson {
                            tempArray.append(fillBlanksChoisesJson.stringValue)
                        }
                        if !tempArray.isEmpty{
                            tempQuestion.fillBlanksChoises = tempArray
                        }
                    }
                    if(key == "multipleChoisesAnswers"){
                        var tempArray = [String]()
                        for (_,multipleChoisesAnswersJson):(String, JSON) in subsubJson {
                            tempArray.append(multipleChoisesAnswersJson.stringValue)
                        }
                        if !tempArray.isEmpty{
                            tempQuestion.multipleChoisesAnswers = tempArray
                        }
                    }
                    if(key == "singleMultipleAnswers"){
                        var tempArray = [String]()
                        for (_,singleMultipleAnswersJson):(String, JSON) in subsubJson {
                            tempArray.append(singleMultipleAnswersJson.stringValue)
                        }
                        if !tempArray.isEmpty{
                            tempQuestion.singleMultipleAnswers = tempArray
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
                tempQuestions.append(tempQuestion)
            }
        }
        return tempQuestions
    }
}
