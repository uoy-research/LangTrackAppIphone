//
//  SingleMultipleAnswersViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class SingleMultipleAnswersViewController: UIViewController {

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var singleMultipleTextLabel: UILabel!
    @IBOutlet weak var answersContainer: UIView!
    @IBOutlet weak var answersContainerHeightConstraint: NSLayoutConstraint!
    
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
        singleMultipleTextLabel.text = theQuestion.text
        fillAnswers()
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    
    func markSelectedAnswer(selected: Int){
        for v in answersContainer.subviews{
            if v is VKCheckbox{
                let check = v as! VKCheckbox
                if check.tag != selected{
                    check.setOn(false, animated: true)
                }
            }
        }
    }
    
    func emptyAnswers(){
        for v in answersContainer.subviews{
            v.removeFromSuperview()
        }
    }
    
    func fillAnswers(){
        emptyAnswers()
        if theQuestion.singleMultipleAnswers != nil{
            let spacer = 10
            let size = 29
            for (i, answer) in theQuestion.singleMultipleAnswers!.enumerated() {
                let check = VKCheckbox(frame: CGRect(x: 0, y: ((size + spacer) * i), width: size, height: size))
                //check.bgColorSelected = .white
                check.bgColorSelected = UIColor(named: "lta_blue") ?? .black
                check.color = .white
                check.borderWidth = 1.5
                check.line = .thin
                check.cornerRadius = check.frame.width / 2
                check.tag = i
                if theAnswer != nil {
                    if theAnswer!.singleMultipleAnswer != nil{
                        if check.tag == theAnswer!.singleMultipleAnswer!{
                            check.setOn(true)
                        }
                    }
                }
                check.checkboxValueChangedBlock = {
                    tag, ison in
                    if ison{
                        self.markSelectedAnswer(selected: tag)
                        self.listener?.setSingleMultipleAnswer(selected: tag)
                    }
                }
                let text = UILabel(frame: CGRect(x: size + spacer, y: ((size + spacer) * i), width: 148, height: size))
                text.text = answer
                text.textAlignment = .left
                text.font = text.font.withSize(19)
                text.contentMode = .center
                text.numberOfLines = 0
                answersContainer.addSubview(check)
                answersContainer.addSubview(text)
                answersContainerHeightConstraint.constant = CGFloat((size + spacer) * (i+1))
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
