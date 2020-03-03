//
//  ViewExtension.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-03.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import Foundation
import UIKit


extension UIView{
    
    func setLargeViewShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -5.0, height: 5.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 1
    }
    
    func setSmallViewShadow(){
        self.layer.shadowColor = UIColor(named: "lta_grey")?.cgColor ?? UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.5)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1
    }
}
