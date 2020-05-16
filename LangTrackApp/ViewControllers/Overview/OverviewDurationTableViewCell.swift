//
//  OverviewDurationTableViewCell.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-07.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class OverviewDurationTableViewCell: UITableViewCell {

    @IBOutlet weak var durationTextLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    
    var question: Question?
    var answer : Answer?
    var answeredHour = 0
    var answeredMinutes = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setValues(item: OverviewListItem?){
        self.question = item?.question
        self.answer = item?.answer
        setHoursAndMinutes()
        durationTextLabel.text = question?.text
        if answeredMinutes == 0 && answeredHour == 0{
            answerTextLabel.text = "0 \(translatedHours) \(translatedAnd) 0 \(translatedMinutes)"
        }else if answeredMinutes == 0{
            if answeredHour == 1{
                answerTextLabel.text = "\(answeredHour) \(translatedHour)"
            }else{
                answerTextLabel.text = "\(answeredHour) \(translatedMinutes)"
            }
        }else{
            if answeredHour == 0{
                answerTextLabel.text = "\(answeredMinutes) \(translatedMinutes)"
            }else{
                if answeredHour == 1{
                    answerTextLabel.text = "\(answeredHour) \(translatedHour) \(translatedAnd) \(answeredMinutes) \(translatedMinutes)"
                }else{
                    answerTextLabel.text = "\(answeredHour) \(translatedHours) \(translatedAnd) \(answeredMinutes) \(translatedMinutes)"
                }
            }
        }
        
    }
    
    func setHoursAndMinutes(){
        if answer?.timeDurationAnswer ?? 0 != 0 {
        answeredHour = answer!.timeDurationAnswer! / (60 * 60)
        answeredMinutes = (answer!.timeDurationAnswer! - (answeredHour * 60 * 60)) / 60
        }
    }

}
