//
//  LikertScaleViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class LikertScaleViewController: UIViewController {
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var listener: QuestionListener?
    var theQuestion = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // temp
        theQuestion.index = 1
        theQuestion.previous = 0
        theQuestion.next = 2
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        listener?.previousQuestion(current: theQuestion)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        listener?.nextQuestion(current: theQuestion)
    }
}
