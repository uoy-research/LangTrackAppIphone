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

extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        let padding: CGFloat = 15
        var textWidth = message.width(withConstrainedHeight: 35, font: font) + padding
        if textWidth > (view.frame.size.width - padding){
            textWidth = view.frame.size.width - padding
        }
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - (textWidth / 2), y: self.view.frame.size.height-80, width: textWidth, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }, completion: {(isCompleted) in
            UIView.animate(withDuration: 1.0, delay: 2.2, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
