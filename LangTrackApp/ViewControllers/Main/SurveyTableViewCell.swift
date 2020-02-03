//
//  SuerveyTableViewCell.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-31.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var surveyBackground: UIView!
    @IBOutlet weak var surveyTitle: UILabel!
    @IBOutlet weak var surveyUnansweredIndicator: UIView!
    @IBOutlet weak var surveyDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        surveyUnansweredIndicator.layer.cornerRadius = 10
        surveyUnansweredIndicator.layer.borderWidth = 0.5
        surveyBackground.layer.borderWidth = 1.5
        surveyBackground.layer.cornerRadius = 8
        surveyBackground.layer.borderColor = UIColor.init(named: "lta_blue")?.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSurveyInfo(survey: Survey)  {
        surveyTitle.text = survey.title
        surveyDate.text = DateParser.displayString(for: Date(timeIntervalSince1970: TimeInterval(survey.date)))
        if (survey.responded) {
            surveyUnansweredIndicator.isHidden = true
        }else{
            surveyUnansweredIndicator.isHidden = false
            surveyUnansweredIndicator.backgroundColor = UIColor.red
        }
    }

}
