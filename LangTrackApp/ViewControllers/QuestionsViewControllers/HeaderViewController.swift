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
    @IBOutlet weak var lu_inageView: UIImageView!
    
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var theUser: User?
    var listener: QuestionListener?
    var theQuestion = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        userNameLabel.text = "Inloggad som\n\(theUser?.userName ?? "noName")"
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
