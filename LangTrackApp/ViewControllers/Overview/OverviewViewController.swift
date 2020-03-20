//
//  OverviewViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-20.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var surveyScroll: UIScrollView!
    @IBOutlet weak var questionContainer: UIView!
    @IBOutlet weak var questionContainerHeightConstraint: NSLayoutConstraint!
    
    
    var theAssignment: Assignment? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showSurvey()
    }
    
    func showSurvey(){
        if theAssignment != nil{
            let height: Int = 50
            for (i, question) in theAssignment!.survey.questions.enumerated() {
                let likertView = LikertView()
                likertView.frame = CGRect(x: 0, y: (height * i), width: Int(questionContainer.frame.width), height: height)
                likertView.setInfo(question: question)
                questionContainer.addSubview(likertView)
            }

            questionContainerHeightConstraint.constant = CGFloat(theAssignment!.survey.questions.count * height)
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
