//
//  LabelExtension.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-05-01.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    func makeUnderlinedTitle(title: String, fontSize: CGFloat, color: String){
        self.attributedText = NSAttributedString(string: title, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue,
             .font: UIFont.systemFont(ofSize: fontSize),
             .foregroundColor: UIColor(named: color)!])
    }
}
