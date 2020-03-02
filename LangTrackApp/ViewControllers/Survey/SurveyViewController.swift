//
//  SurveyViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {
    @IBOutlet weak var surveyContainer: UIView!
    
    var theSurvey: Survey? = nil
    var currentPage = Question()
    var theUser: User?
    
    var header: HeaderViewController?
    var likertScale: LikertScaleViewController?
    var fillInTheBlank: FillInTheBlankViewController?
    var multipleChoice: MultipleChoiceViewController?
    var singleMultipleAnswers: SingleMultipleAnswersViewController?
    var openEndedTextResponses: OpenEndedTextResponsesViewController?
    var footer: FooterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        header = storyboard.instantiateViewController(withIdentifier: "header") as? HeaderViewController
        header?.setListener(listener: self)
        header?.theUser = self.theUser
        
        likertScale = storyboard.instantiateViewController(withIdentifier: "likertScale") as? LikertScaleViewController
        likertScale?.setListener(listener: self)
        
        fillInTheBlank = storyboard.instantiateViewController(withIdentifier: "fillInTheBlank") as? FillInTheBlankViewController
        fillInTheBlank?.setListener(listener: self)
        
        multipleChoice = storyboard.instantiateViewController(withIdentifier: "multipleChoice") as? MultipleChoiceViewController
        multipleChoice?.setListener(listener: self)
        
        singleMultipleAnswers = storyboard.instantiateViewController(withIdentifier: "singleMultipleAnswer") as? SingleMultipleAnswersViewController
        singleMultipleAnswers?.setListener(listener: self)
        
        openEndedTextResponses = storyboard.instantiateViewController(withIdentifier: "openEndedTextResponses") as? OpenEndedTextResponsesViewController
        openEndedTextResponses?.setListener(listener: self)
        
        footer = storyboard.instantiateViewController(withIdentifier: "footer") as? FooterViewController
        footer?.setListener(listener: self)
        
        //to convert to json
        //print(theSurvey!.convertToString!)
        
        if theSurvey?.questions.first != nil{
            showPage(newPage: theSurvey!.questions.first!)
        }//TODO popup if error
    }
    

    func showPage(newPage : Question)
    {
        var theQuestion = Question()
        for ques in theSurvey!.questions {
            if ques.index == newPage.index{
                theQuestion = ques
            }
        }
        // STÄDA BORT CURRENT
        if(currentPage.type == Type.header.rawValue)
        {
            header!.willMove(toParent: nil)
            header!.view.removeFromSuperview()
            header!.removeFromParent()
        }
        if(currentPage.type == Type.likertScales.rawValue)
        {
            likertScale!.willMove(toParent: nil)
            likertScale!.view.removeFromSuperview()
            likertScale!.removeFromParent()
        }
        if(currentPage.type == Type.fillInTheBlank.rawValue)
        {
            fillInTheBlank!.willMove(toParent: nil)
            fillInTheBlank!.view.removeFromSuperview()
            fillInTheBlank!.removeFromParent()
        }
        if(currentPage.type == Type.multipleChoice.rawValue)
        {
            multipleChoice!.willMove(toParent: nil)
            multipleChoice!.view.removeFromSuperview()
            multipleChoice!.removeFromParent()
        }
        if(currentPage.type == Type.singleMultipleAnswers.rawValue)
        {
            singleMultipleAnswers!.willMove(toParent: nil)
            singleMultipleAnswers!.view.removeFromSuperview()
            singleMultipleAnswers!.removeFromParent()
        }
        if(currentPage.type == Type.openEndedTextResponses.rawValue)
        {
            openEndedTextResponses!.willMove(toParent: nil)
            openEndedTextResponses!.view.removeFromSuperview()
            openEndedTextResponses!.removeFromParent()
        }
        if(currentPage.type == Type.footer.rawValue)
        {
            footer!.willMove(toParent: nil)
            footer!.view.removeFromSuperview()
            footer!.removeFromParent()
        }
        currentPage = newPage
        
        
        if(currentPage.type == Type.header.rawValue)
        {
            self.addChild(header!)
            surveyContainer.addSubview(header!.view)
            header!.view.frame = surveyContainer.bounds
            header!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            header!.didMove(toParent: self)
            header!.setInfo(question: theQuestion)
        }
        if(currentPage.type == Type.likertScales.rawValue)
        {
            self.addChild(likertScale!)
            surveyContainer.addSubview(likertScale!.view)
            likertScale!.view.frame = surveyContainer.bounds
            likertScale!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            likertScale!.didMove(toParent: self)
            likertScale!.theAnswer = theSurvey!.answer[currentPage.index]
            likertScale!.setInfo(question: theQuestion)
        }
        if(currentPage.type == Type.fillInTheBlank.rawValue)
        {
            self.addChild(fillInTheBlank!)
            surveyContainer.addSubview(fillInTheBlank!.view)
            fillInTheBlank!.view.frame = surveyContainer.bounds
            fillInTheBlank!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            fillInTheBlank!.didMove(toParent: self)
            fillInTheBlank!.setInfo(question: theQuestion)
        }
        if(currentPage.type == Type.multipleChoice.rawValue)
        {
            self.addChild(multipleChoice!)
            surveyContainer.addSubview(multipleChoice!.view)
            multipleChoice!.view.frame = surveyContainer.bounds
            multipleChoice!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            multipleChoice!.didMove(toParent: self)
            multipleChoice!.theAnswer = theSurvey!.answer[currentPage.index]
            multipleChoice!.setInfo(question: theQuestion)
        }
        if(currentPage.type == Type.singleMultipleAnswers.rawValue)
        {
            self.addChild(singleMultipleAnswers!)
            surveyContainer.addSubview(singleMultipleAnswers!.view)
            singleMultipleAnswers!.view.frame = surveyContainer.bounds
            singleMultipleAnswers!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            singleMultipleAnswers!.didMove(toParent: self)
            singleMultipleAnswers!.theAnswer = theSurvey!.answer[currentPage.index]
            singleMultipleAnswers!.setInfo(question: theQuestion)
        }
        if(currentPage.type == Type.openEndedTextResponses.rawValue)
        {
            self.addChild(openEndedTextResponses!)
            surveyContainer.addSubview(openEndedTextResponses!.view)
            openEndedTextResponses!.view.frame = surveyContainer.bounds
            openEndedTextResponses!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            openEndedTextResponses!.didMove(toParent: self)
            openEndedTextResponses!.setInfo(question: theQuestion)
        }
        if(currentPage.type == Type.footer.rawValue)
        {
            self.addChild(footer!)
            surveyContainer.addSubview(footer!.view)
            footer!.view.frame = surveyContainer.bounds
            footer!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            footer!.didMove(toParent: self)
            footer!.setInfo(question: theQuestion)
        }
    }

}

//MARK:- QuestionListener
extension SurveyViewController: QuestionListener{
    func setLikertAnswer(selected: Int) {
        if theSurvey != nil{
            theSurvey!.answer[currentPage.index] = Answer(likertAnswer: selected, fillBlankAnswer: nil, multipleChoiceAnswer: nil, singleMultipleAnswer: nil, openEndedAnswer: nil)
        }
    }
    
    func setMultipleAnswersAnswer(selected: [Int]) {
        if theSurvey != nil{
            theSurvey!.answer[currentPage.index] = Answer(likertAnswer: nil, fillBlankAnswer: nil, multipleChoiceAnswer: selected, singleMultipleAnswer: nil, openEndedAnswer: nil)
        }
    }
    
    
    func setSingleMultipleAnswer(selected: Int) {
        if theSurvey != nil{
            theSurvey!.answer[currentPage.index] = Answer(likertAnswer: nil, fillBlankAnswer: nil, multipleChoiceAnswer: nil, singleMultipleAnswer: selected, openEndedAnswer: nil)
        }
    }
    
    
    func closeSurvey() {
        print("closeSurvey")
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendInSurvey() {
        print("sendInSurvey")
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func nextQuestion(current: Question) {
        print("nextQuestion: \(current.next ?? 0)")
        if theSurvey != nil{
            for q in theSurvey!.questions {
                if q.index == current.next{
                    showPage(newPage: q)
                }
            }
        }
    }
    
    func previousQuestion(current: Question) {
        print("previousQuestion: \(current.previous ?? 0)")
        if theSurvey != nil{
            for q in theSurvey!.questions {
                if q.index == current.previous{
                    showPage(newPage: q)
                }
            }
        }
    }
}
