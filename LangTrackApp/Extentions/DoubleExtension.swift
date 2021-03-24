//
//  DoubleExtension.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2021-03-14.
//  Copyright © 2021 Stephan Björck. All rights reserved.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
