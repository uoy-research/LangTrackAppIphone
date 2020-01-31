//
//  DateParser.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-31.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation


struct DateParser {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "sv_SE")
    return formatter
  }()
  
  //Wed, 04 Nov 2015 21:00:14 +0000
  static func dateWithPodcastDateString(_ dateString: String) -> Date? {
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    return dateFormatter.date(from: dateString)
  }
  
    //2019-12-29 12:42
  static func displayString(for date: Date) -> String {
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.string(from: date)
  }
}
