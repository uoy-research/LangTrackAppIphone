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
    @IBOutlet weak var radioButton1: LikertRadioButton!
    
    @IBOutlet weak var radioButton2: LikertRadioButton!
    
    @IBOutlet weak var radioButton3: LikertRadioButton!
    
    @IBOutlet weak var radioButton4: LikertRadioButton!
    
    @IBOutlet weak var radioButton5: LikertRadioButton!
    
    
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
    
    func deselectAllRadiobuttons(){
        radioButton1.isSelected = false
        radioButton2.isSelected = false
        radioButton3.isSelected = false
        radioButton4.isSelected = false
        radioButton5.isSelected = false
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        listener?.previousQuestion(current: theQuestion)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        listener?.nextQuestion(current: theQuestion)
    }
    
    @IBAction func likertButtonPressed(_ sender: LikertRadioButton) {
        deselectAllRadiobuttons()
        sender.isSelected = !sender.isSelected
    }
}
