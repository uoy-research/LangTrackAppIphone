//
//  SuerveyTableViewCell.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-31.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var surveyBackground: UIView!
    @IBOutlet weak var surveyTitle: UILabel!
    @IBOutlet weak var answeredLabel: UILabel!
    
    let dateformat = "yyyy-MM-dd HH:mm"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setSurveyInfo(assignment: Assignment)  {
        surveyTitle.text = assignment.survey.title
        if assignment.published != nil{
            dateLabel.text = DateParser.displayString(for: DateParser.getDate(dateString: assignment.dataset!.createdAt)!)
        }
        if assignment.dataset == nil{
            answeredLabel.text = "Obesvarad"
        }else{
            answeredLabel.text = "Besvarad"
        }
    }
}
