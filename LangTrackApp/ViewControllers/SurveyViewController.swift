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
    var currentPage = Type.header.rawValue
    
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
        header = storyboard.instantiateViewController(withIdentifier: "header") as! HeaderViewController
        header?.setListener(listener: self)
        likertScale = storyboard.instantiateViewController(withIdentifier: "likertScale") as! LikertScaleViewController
        likertScale?.setListener(listener: self)
        fillInTheBlank = storyboard.instantiateViewController(withIdentifier: "fillInTheBlank") as! FillInTheBlankViewController
        multipleChoice = storyboard.instantiateViewController(withIdentifier: "multipleChoice") as! MultipleChoiceViewController
        singleMultipleAnswers = storyboard.instantiateViewController(withIdentifier: "singleMultipleAnswer") as! SingleMultipleAnswersViewController
        openEndedTextResponses = storyboard.instantiateViewController(withIdentifier: "openEndedTextResponses") as! OpenEndedTextResponsesViewController
        footer = storyboard.instantiateViewController(withIdentifier: "footer") as! FooterViewController
        
        showPage(newPage: Type.header.rawValue)
    }
    

    func showPage(newPage : Int)
    {
        // STÄDA BORT CURRENT
        if(currentPage == Type.header.rawValue)
        {
            header!.willMove(toParent: nil)
            header!.view.removeFromSuperview()
            header!.removeFromParent()
        }
        if(currentPage == Type.likertScales.rawValue)
        {
            likertScale!.willMove(toParent: nil)
            likertScale!.view.removeFromSuperview()
            likertScale!.removeFromParent()
        }
        if(currentPage == Type.fillInTheBlank.rawValue)
        {
            fillInTheBlank!.willMove(toParent: nil)
            fillInTheBlank!.view.removeFromSuperview()
            fillInTheBlank!.removeFromParent()
        }
        if(currentPage == Type.multipleChoice.rawValue)
        {
            multipleChoice!.willMove(toParent: nil)
            multipleChoice!.view.removeFromSuperview()
            multipleChoice!.removeFromParent()
        }
        if(currentPage == Type.singleMultipleAnswers.rawValue)
        {
            singleMultipleAnswers!.willMove(toParent: nil)
            singleMultipleAnswers!.view.removeFromSuperview()
            singleMultipleAnswers!.removeFromParent()
        }
        if(currentPage == Type.openEndedTextResponses.rawValue)
        {
            openEndedTextResponses!.willMove(toParent: nil)
            openEndedTextResponses!.view.removeFromSuperview()
            openEndedTextResponses!.removeFromParent()
        }
        if(currentPage == Type.footer.rawValue)
        {
            footer!.willMove(toParent: nil)
            footer!.view.removeFromSuperview()
            footer!.removeFromParent()
        }
        currentPage = newPage
        
        
        if(currentPage == Type.header.rawValue)
        {
            self.addChild(header!)
            surveyContainer.addSubview(header!.view)
            header!.view.frame = surveyContainer.bounds
            header!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            header!.didMove(toParent: self)
        }
        if(currentPage == Type.likertScales.rawValue)
        {
            self.addChild(likertScale!)
            surveyContainer.addSubview(likertScale!.view)
            likertScale!.view.frame = surveyContainer.bounds
            likertScale!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            likertScale!.didMove(toParent: self)
        }
        if(currentPage == Type.fillInTheBlank.rawValue)
        {
            self.addChild(fillInTheBlank!)
            surveyContainer.addSubview(fillInTheBlank!.view)
            fillInTheBlank!.view.frame = surveyContainer.bounds
            fillInTheBlank!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            fillInTheBlank!.didMove(toParent: self)
        }
        if(currentPage == Type.multipleChoice.rawValue)
        {
            self.addChild(multipleChoice!)
            surveyContainer.addSubview(multipleChoice!.view)
            multipleChoice!.view.frame = surveyContainer.bounds
            multipleChoice!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            multipleChoice!.didMove(toParent: self)
        }
        if(currentPage == Type.singleMultipleAnswers.rawValue)
        {
            self.addChild(singleMultipleAnswers!)
            surveyContainer.addSubview(singleMultipleAnswers!.view)
            singleMultipleAnswers!.view.frame = surveyContainer.bounds
            singleMultipleAnswers!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            singleMultipleAnswers!.didMove(toParent: self)
        }
        if(currentPage == Type.openEndedTextResponses.rawValue)
        {
            self.addChild(openEndedTextResponses!)
            surveyContainer.addSubview(openEndedTextResponses!.view)
            openEndedTextResponses!.view.frame = surveyContainer.bounds
            openEndedTextResponses!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            openEndedTextResponses!.didMove(toParent: self)
        }
        if(currentPage == Type.footer.rawValue)
        {
            self.addChild(footer!)
            surveyContainer.addSubview(footer!.view)
            footer!.view.frame = surveyContainer.bounds
            footer!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            footer!.didMove(toParent: self)
        }
    }

}

extension SurveyViewController: QuestionListener{
    
    func closeSurvey() {
        print("closeSurvey")
    }
    
    func sendInSurvey() {
        print("sendInSurvey")
    }
    
    func nextQuestion(current: Question) {
        print("nextQuestion: \(current.next)")
        showPage(newPage: current.next)
    }
    
    func previousQuestion(current: Question) {
        print("previousQuestion: \(current.previous)")
        showPage(newPage: current.previous)
    }
}
