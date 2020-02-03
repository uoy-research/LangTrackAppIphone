//
//  StringExtension.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-02-03.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

extension String {

    mutating func until(_ string: String) {
        let components = self.components(separatedBy: string)
        self = components[0]
    }

}
