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
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var listener: QuestionListener?
    var theQuestion = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        tempLabel.text = theQuestion.text
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
