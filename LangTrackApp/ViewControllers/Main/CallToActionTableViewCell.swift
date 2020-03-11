//
//  CallToActionTableViewCell.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-07.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class CallToActionTableViewCell: UITableViewCell {

    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var callToActionBackgroundView: UIView!
    @IBOutlet weak var callToActionLabel: UILabel!
    @IBOutlet weak var callToActionHeightConstraint: NSLayoutConstraint!
    
    var theSurvey : Survey? = nil
    var listener: CellTimerListener? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        callToActionBackgroundView.layer.cornerRadius = 15
        //update label every minute
        Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setListener(theListener: CellTimerListener){
        self.listener = theListener
    }
    
    @objc func updateCounter() {
        setExpieryTime()
    }
    
    func setExpieryTime(){
        if theSurvey != nil{
            if theSurvey!.expiry != nil{
                let millisecondsLeft = theSurvey!.expiry! - Date().millisecondsSince1970
                expiryLabel.text = "Tid kvar: \(TimeInterval().stringFromSecondTimeInterval(time: millisecondsLeft / 1000) )"
                if millisecondsLeft <= 0{
                    listener?.timerExpiered()
                }
            }
        }
    }
    
    func setSurveyInfo(survey: Survey, tableviewHeight: CGFloat)  {
        self.callToActionHeightConstraint.constant = tableviewHeight / 3
        self.theSurvey = survey
        //self.callToActionLabel.text  = survey.title
        setExpieryTime()
    }

}
