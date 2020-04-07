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
            answerTextLabel.text = "0:0"
        }else if answeredMinutes == 0{
            if answeredHour == 1{
                answerTextLabel.text = "\(answeredHour) timme"
            }else{
                answerTextLabel.text = "\(answeredHour) timmar"
            }
        }else{
            if answeredHour == 0{
                answerTextLabel.text = "\(answeredMinutes) minuter"
            }else{
                if answeredHour == 1{
                    answerTextLabel.text = "\(answeredHour) timme och \(answeredMinutes) minuter"
                }else{
                    answerTextLabel.text = "\(answeredHour) timmar och \(answeredMinutes) minuter"
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
