//
//  TimeDurationViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-06.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class TimeDurationViewController: UIViewController {
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var theIcon: UIImageView!
    @IBOutlet weak var durationTextLabel: UILabel!
    @IBOutlet weak var durationPicker: UIDatePicker!
    
    var theUser: User?
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
        durationTextLabel.text = theQuestion.text
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    @IBAction func durationPickerChanged(_ sender: UIDatePicker) {
        //get seconds
        print("sender.countDownDuration: \(sender.countDownDuration)")
        
        //get minutes and hours
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: sender.date)
        let hour = comp.hour
        let minute = comp.minute
        print("durationPickerChanged hour: \(hour ?? 0), minute: \(minute ?? 0)")
    }
    

    @IBAction func previousButtonPressed(_ sender: Any) {
        listener?.previousQuestion(current: theQuestion)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        listener?.nextQuestion(current: theQuestion)
    }
    
}
