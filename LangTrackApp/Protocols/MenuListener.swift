//
//  MenuListener.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-24.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

protocol MenuListener{
    func logOutSelected()
    func contact()
    func about()
    func setTestMode(to: Bool)
}
