//
//  MultipleChoiceViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class MultipleChoiceViewController: UIViewController {
    
    @IBOutlet weak var nextButton: NextButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var multipleChoiceTextLabel: UILabel!
    @IBOutlet weak var choicesContainer: UIView!
    @IBOutlet weak var checkboxContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerBackground: UIView!
    @IBOutlet weak var checkboxContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var theIcon: UIImageView!
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
        multipleChoiceTextLabel.text = theQuestion.text
        nextButton.setEnabled(enabled: false)
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
    
    func checkCheckboxesIfSelected(){
        for v in choicesContainer.subviews{
            if let theCheckbox = v as? VKCheckbox{
                if theCheckbox.isOn{
                    nextButton.setEnabled(enabled: true)
                    break
                }else{
                    nextButton.setEnabled(enabled: false)
                }
            }
        }
    }
    
    func fillCheckboxContainer(){
        emptyCheckboxContainer()
        let spacer = 10
        let size = 29
        var maxIntrinsicWidth: CGFloat = 100
        if theQuestion.multipleChoisesAnswers != nil{
            for (i, choice) in theQuestion.multipleChoisesAnswers!.enumerated() {
                let check = VKCheckbox(frame: CGRect(x: 0, y: ((size + spacer) * i), width: size, height: size))
                //check.bgColorSelected = .white
                check.bgColorSelected = UIColor(named: "lta_blue") ?? .black
                check.color = .white
                check.borderWidth = 1.5
                check.tag = i
                if theAnswer != nil {
                    if theAnswer?.index == theQuestion.index{
                        if theAnswer!.multipleChoiceAnswer != nil{
                            if theAnswer!.multipleChoiceAnswer!.contains(check.tag){
                                check.setOn(true)
                                nextButton.setEnabled(enabled: true)
                            }
                        }
                    }
                }
                check.checkboxValueChangedBlock = {
                    tag, ison in
                    print("value \(tag) is \(ison)")
                    self.saveAnswers()
                    self.checkCheckboxesIfSelected()
                }
                let containerWidth = Int(containerBackground.frame.width * 0.92) - size - spacer
                let text = UILabel(frame: CGRect(x: size + spacer, y: ((size + spacer) * i), width: containerWidth, height: size))
                text.text = choice
                text.textAlignment = .left
                text.font = text.font.withSize(19)
                text.contentMode = .center
                text.numberOfLines = 0
                if text.intrinsicContentSize.width > maxIntrinsicWidth{
                    maxIntrinsicWidth = text.intrinsicContentSize.width
                }
                choicesContainer.addSubview(check)
                choicesContainer.addSubview(text)
                checkboxContainerHeightConstraint.constant = CGFloat((size + spacer) * (i+1))
            }
            if (maxIntrinsicWidth + CGFloat(size + spacer)) < containerBackground.frame.width{
                checkboxContainerWidthConstraint.constant = maxIntrinsicWidth + CGFloat(size + spacer)
            }else{
                checkboxContainerWidthConstraint.constant = containerBackground.frame.width
            }
        }
    }
    
    func saveAnswers(){
        var answers = [Int]()
        for v in choicesContainer.subviews{
            if v is VKCheckbox{
                let check = v as! VKCheckbox
                if check.isOn{
                    if !answers.contains(check.tag){
                        answers.append(check.tag)
                    }
                }
            }
        }
        listener?.setMultipleAnswersAnswer(selected: answers)
    }

    @IBAction func previousButtonPressed(_ sender: Any) {
        listener?.previousQuestion(current: theQuestion)
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        listener?.nextQuestion(current: theQuestion)
    }
}
