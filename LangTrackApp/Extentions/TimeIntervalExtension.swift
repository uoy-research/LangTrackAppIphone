//
//  TimeIntervalExtension.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-08.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

extension TimeInterval{
    
    func stringFromSecondTimeInterval(time: Int64) -> String {
        
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        var formatString = ""
        if hours == 0 {
            if(minutes < 10) {
                formatString = "%2d minuter"
            }else {
                formatString = "%0.2d minuter"
            }
            return String(format: formatString,minutes)
        }else {
            formatString = "%2d timmar och %0.2d minuter"
            return String(format: formatString,hours,minutes)
        }
    }
}
