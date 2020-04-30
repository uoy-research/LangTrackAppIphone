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
    
    @IBOutlet weak var minutesPickerView: UIPickerView!
    @IBOutlet weak var hourPickerView: UIPickerView!
    var theUser: User?
    var listener: QuestionListener?
    var theQuestion = Question()
    var theAnswer: Answer?
    var selectedHour = 0
    var selectedMinutes = 0
    let hours = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"]
    let minutes = ["00","05","10","15","20","25","30","35","40","45","50","55"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8
        theIcon.clipsToBounds = false
        theIcon.setSmallViewShadow()
        hourPickerView.delegate = self
        minutesPickerView.delegate = self
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        durationTextLabel.text = theQuestion.text
        setTimePickers()
    }
    
    func setTimePickers(){
        if self.theAnswer?.timeDurationAnswer != nil{
            let seconds = self.theAnswer!.timeDurationAnswer ?? 0
            if seconds != 0 {
                selectedHour = seconds / (60 * 60)
                selectedMinutes = (seconds - (selectedHour * 60 * 60)) / 60
                
                let hoursInString = String(selectedHour)
                var minutesInString = String(selectedMinutes)
                if minutesInString == "0"{
                    minutesInString = "00"
                }else if minutesInString == "5"{
                    minutesInString = "05"
                }
                hourPickerView.selectRow(hours.firstIndex(of: hoursInString) ?? 0, inComponent: 0, animated: false)
                minutesPickerView.selectRow(minutes.firstIndex(of: minutesInString) ?? 0, inComponent: 0, animated: false)
            }
        }else{
            hourPickerView.selectRow(0, inComponent: 0, animated: false)
            minutesPickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    
    func setAnswer() -> Int{
        //hours and minutes to seconds
        var tempDuration = 0
        tempDuration += (selectedHour * 60 * 60)
        tempDuration += (selectedMinutes * 60)
        return tempDuration
    }
    

    @IBAction func previousButtonPressed(_ sender: Any) {
        listener?.setTimeDurationAnswer(selected: setAnswer())
        listener?.previousQuestion(current: theQuestion)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        listener?.setTimeDurationAnswer(selected: setAnswer())
        listener?.nextQuestion(current: theQuestion)
    }
    
}

extension TimeDurationViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return hours.count
        }else if pickerView.tag == 1{
            return minutes.count
        }else{
            return 0
        }
            
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hours[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let hourwidth = hourPickerView.frame.width
        let minutewidth = minutesPickerView.frame.width
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 35)
        if pickerView.tag == 0{
            view.frame = CGRect(x: 0, y: 0, width: Int(hourwidth), height: 45)
            view.textAlignment = .right
            view.text = hours[row]
        }else{
            view.frame = CGRect(x: 0, y: 0, width: Int(minutewidth), height: 45)
            view.textAlignment = .left
            view.text = minutes[row]
        }
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            selectedHour = Int.init(hours[row]) ?? 0
        }else if pickerView.tag == 1{
            selectedMinutes = Int.init(minutes[row]) ?? 0
        }
    }
}
