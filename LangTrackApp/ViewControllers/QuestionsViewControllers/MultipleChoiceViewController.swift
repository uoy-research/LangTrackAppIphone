//
//  MultipleChoiceViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class MultipleChoiceViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var multipleChoiceTextLabel: UILabel!
    @IBOutlet weak var choicesContainer: UIView!
    @IBOutlet weak var checkboxContainerHeightConstraint: NSLayoutConstraint!
    
    var listener: QuestionListener?
    var theQuestion = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8
        
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        multipleChoiceTextLabel.text = theQuestion.text
        fillCheckboxContainer()
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    
    func emptyCheckboxContainer(){
        for v in choicesContainer.subviews{
            v.removeFromSuperview()
        }
    }
    
    func fillCheckboxContainer(){
        emptyCheckboxContainer()
        let spacer = 10
        let size = 29
        if theQuestion.multipleChoisesAnswers != nil{
            for (i, choice) in theQuestion.multipleChoisesAnswers!.enumerated() {
                let check = VKCheckbox(frame: CGRect(x: 0, y: ((size + spacer) * i), width: size, height: size))
                //check.bgColorSelected = .white
                check.bgColorSelected = UIColor(named: "lta_blue") ?? .black
                check.color = .white
                check.borderWidth = 1.5
                check.tag = i
                check.checkboxValueChangedBlock = {
                    tag, ison in
                    print("value \(tag) is \(ison)")
                }
                let text = UILabel(frame: CGRect(x: size + spacer, y: ((size + spacer) * i), width: 148, height: size))
                text.text = choice
                text.textAlignment = .left
                text.font = text.font.withSize(19)
                text.contentMode = .center
                text.numberOfLines = 0
                choicesContainer.addSubview(check)
                choicesContainer.addSubview(text)
                checkboxContainerHeightConstraint.constant = CGFloat((size + spacer) * (i+1))
            }
        }
    }

    @IBAction func previousButtonPressed(_ sender: Any) {
        listener?.previousQuestion(current: theQuestion)
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        listener?.nextQuestion(current: theQuestion)
    }
}
