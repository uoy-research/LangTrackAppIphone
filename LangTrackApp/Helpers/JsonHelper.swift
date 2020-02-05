//
//  JsonHelper.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-02-05.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation


struct JsonHelper {
    static func getJson(completionhandler: @escaping (_ result: [Survey]?) -> Void){
        let request = NSMutableURLRequest(url: URL(string: "https://www.dropbox.com/s/0iubma625aax6vg/survey_json.txt?dl=1")!)//sista nollan ska ändras till etta!!!
        let session = URLSession.shared
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                print("AJDÅ DET GICK FEL")
                completionhandler(nil)
                return
            }
            do {
                do {
                    // Decode data to object
                    
                    let jsonDecoder = JSONDecoder()
                    let theSurvey = try jsonDecoder.decode([Survey].self, from: data!)
                    completionhandler(theSurvey)
                }
                catch {
                    print("ERROR call")
                    completionhandler(nil)
                }
            }
        })
        task.resume()
    }
}
