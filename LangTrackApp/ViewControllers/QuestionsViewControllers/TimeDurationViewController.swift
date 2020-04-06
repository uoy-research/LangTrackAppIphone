//
//  TimeDurationViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-06.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class TimeDurationViewController: UIViewController {
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var theIcon: UIImageView!
    @IBOutlet weak var durationTextLabel: UILabel!
    
    var theUser: User?
    var listener: QuestionListener?
    var theQuestion = Question()
    var theAnswer: Answer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8
        theIcon.clipsToBounds = false
        theIcon.setSmallViewShadow()
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        durationTextLabel.text = theQuestion.text
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    

    @IBAction func previousButtonPressed(_ sender: Any) {
        listener?.closeSurvey()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        listener?.nextQuestion(current: theQuestion)
    }
    
}
