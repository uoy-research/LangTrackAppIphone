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
    @IBOutlet weak var radioButton1: LikertRadioButton!
    @IBOutlet weak var radioButton2: LikertRadioButton!
    @IBOutlet weak var radioButton3: LikertRadioButton!
    @IBOutlet weak var radioButton4: LikertRadioButton!
    @IBOutlet weak var radioButton5: LikertRadioButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likertTextLabel: UILabel!
    @IBOutlet weak var radioButtonContainer: UIView!
    @IBOutlet weak var likertContainer: UIView!
    
    
    
    var listener: QuestionListener?
    var theQuestion = Question()
    var theAnswer: Answer? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        //radioButton3.isSelected = true
        likertTextLabel.text = theQuestion.text
        descriptionLabel.text = theQuestion.description
        if theAnswer != nil {
            if theAnswer!.likertAnswer != nil{
                setSelected(selected: theAnswer!.likertAnswer ?? 10)
            }
        }
    }
    
    func setSelected(selected: Int){
        switch selected {
        case 0:
            radioButton1.isSelected = true
            radioButton2.isSelected = false
            radioButton3.isSelected = false
            radioButton4.isSelected = false
            radioButton5.isSelected = false
        case 1:
            radioButton1.isSelected = false
            radioButton2.isSelected = true
            radioButton3.isSelected = false
            radioButton4.isSelected = false
            radioButton5.isSelected = false
        case 2:
            radioButton1.isSelected = false
            radioButton2.isSelected = false
            radioButton3.isSelected = true
            radioButton4.isSelected = false
            radioButton5.isSelected = false
        case 3:
            radioButton1.isSelected = false
            radioButton2.isSelected = false
            radioButton3.isSelected = false
            radioButton4.isSelected = true
            radioButton5.isSelected = false
        case 4:
            radioButton1.isSelected = false
            radioButton2.isSelected = false
            radioButton3.isSelected = false
            radioButton4.isSelected = false
            radioButton5.isSelected = true
        default:
            print("likert setSelected: \(selected)")
        }
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
        listener?.setLikertAnswer(selected: sender.tag)
    }
}
