//
//  HeaderViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var listener: QuestionListener?
    var theQuestion = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // temp
        theQuestion.index = 0
        theQuestion.next = 1
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    

    @IBAction func closeButtonPressed(_ sender: Any) {
        listener?.closeSurvey()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        listener?.nextQuestion(current: theQuestion)
    }
    
}
