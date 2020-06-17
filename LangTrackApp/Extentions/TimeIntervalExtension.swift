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
        
        var minutesString = translatedMinutes
        if minutes == 1{
            minutesString = translatedMinute
        }
        var hourString = translatedHours
        if hours == 1{
            hourString = translatedHour
        }
        
        var formatString = ""
        if hours == 0 {
            if(minutes < 10) {
                formatString = "%2d \(minutesString)"
            }else {
                formatString = "%0.2d \(minutesString)"
            }
            return String(format: formatString,minutes)
        }else {
            formatString = "%2d \(hourString) \(translatedAnd) %0.2d \(minutesString)"
            return String(format: formatString,hours,minutes)
        }
    }
}
