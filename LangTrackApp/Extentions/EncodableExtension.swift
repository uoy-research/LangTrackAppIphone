//
//  EncodableExtension.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-02-05.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

extension Encodable {
    var convertToString: String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
