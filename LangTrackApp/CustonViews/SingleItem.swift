//
//  SingleItem.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-03.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

@IBDesignable
class SingleItem: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var checkbox: VKCheckbox!
    @IBOutlet weak var textLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func setInfo(choice: String){
        textLabel.text = choice
    }
    
    func getIntrWidth() -> CGFloat{
        return textLabel.intrinsicContentSize.width
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("SingleItem", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        checkbox.bgColorSelected = .white
        checkbox.bgColorSelected = UIColor(named: "lta_blue") ?? .black
        checkbox.color = .white
        checkbox.borderWidth = 1.5
        checkbox.line = .thin
        checkbox.cornerRadius = checkbox.frame.width / 2
    }
}

