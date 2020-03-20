//
//  LikertView.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-20.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class LikertView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var testLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func setInfo(question: Question){
        testLabel.text = String(question.index)
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("LikertView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
