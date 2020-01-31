//
//  FooterViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class FooterViewController: UIViewController {

    @IBOutlet weak var sendInButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    var listener: QuestionListener?
    var theQuestion = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // temp
        theQuestion.index = 6
        theQuestion.previous = 5
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        listener?.previousQuestion(current: theQuestion)
    }
    
    @IBAction func sendInButtonPressed(_ sender: Any) {
        listener?.closeSurvey()
    }
    
}
