//
//  User.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-02-04.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation

struct User {
    var id = ""
    var userName = ""
    var userEmail = ""
    
    init(userName: String, mail: String) {
        self.userName = userName
        self.userEmail = mail
    }
}
