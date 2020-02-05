//
//  JsonHelper.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-02-05.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation


struct JsonHelper {
    
    //sista nollan ska ändras till etta vid hämtning från dropbox
    static let theUrl = "https://www.dropbox.com/s/0iubma625aax6vg/survey_json.txt?dl=1"
    
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
            completionhandler(parseJson(data: data!))
        })
        task.resume()
    }
    
    
    private static func parseJson(data: Data) -> [Survey]?{
        // Decode data to object
        var returnValue: [Survey]?
        do {
            returnValue = try JSONDecoder().decode([Survey].self, from: data)
        } catch {
            print("Error took place\(error.localizedDescription).")
        }
        return returnValue
    }
}
