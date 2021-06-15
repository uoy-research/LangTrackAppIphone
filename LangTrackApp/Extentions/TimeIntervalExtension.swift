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
        
        let days = (time / 86400)
        let hours = ((time % 86400) / 3600)
        let minutes = ((time % 3600) / 60) % 60
        var dayFormat = "%0.2d"
        var hourFormat = "%0.2d"
        var minuteFormat = "%0.2d"
        var minutesString = translatedMinutes
        
        if days < 10{
            dayFormat = "%2d"
        }
        if hours < 10{
            hourFormat = "%2d"
        }
        if minutes < 10{
            minuteFormat = "%2d"
        }
        
        if minutes == 1{
            minutesString = translatedMinute
        }
        var hourString = translatedHours
        if hours == 1{
            hourString = translatedHour
        }
        var dayString = translatedDays
        if days == 1{
            dayString = translatedDay
        }
        
        var formatString = ""
        if days > 0{
            formatString.append("\(dayFormat) \(dayString) \(hourFormat) \(hourString) \(translatedAnd) \(minuteFormat) \(minutesString)")
        }else if hours > 0{
            formatString.append("\(hourFormat) \(hourString) \(translatedAnd) \(minuteFormat) \(minutesString)")
        }else{
            formatString.append("\(minuteFormat) \(minutesString)")
        }
        if days > 0 {
            return String(format: formatString, days, hours, minutes)
        }else if hours > 0{
            return String(format: formatString, hours, minutes)
        }else {
            return String(format: formatString, minutes)
        }
        // 1 minut
        // 20 minuter
        // 1 timme och 1 minut
        // 1 timme och 20 minuter
        // 20 timmar och 1 minut
        // 20 timmar och 20 minuter
        // 1 dag 1 timme och 1 minut
        // 1 dag 1 timme och 20 minuter
        // 1 dag 20 timmar och 20 minuter
        // 20 dagar 1 timme och 1 minut
        // 20 dagar 1 timme och 20 minuter
        // 20 dagar 20 timmar och 20 minuter
    }
}
