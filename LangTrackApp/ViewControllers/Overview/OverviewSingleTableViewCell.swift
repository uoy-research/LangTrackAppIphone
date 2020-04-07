//
//  OverviewSingleTableViewCell.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-07.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class OverviewSingleTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var singleStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var singleTextLabel: UILabel!
    
    var question: Question?
    var answer : Answer?
    
    
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
        let selectedChoice = self.answer?.singleMultipleAnswer
        fillAnswers(answer: selectedChoice ?? -99)
        singleTextLabel.text = item?.question.text
    }
    
    func fillAnswers(answer: Int){
        if question != nil{
            if question!.singleMultipleAnswers != nil{
                let viewWidth = Int(singleStackView.frame.width - 20)
                var heightCounter = 0
                for (i, choice) in question!.singleMultipleAnswers!.enumerated() {
                    let height = choice.height(withConstrainedWidth: CGFloat(viewWidth - 40), font: UIFont.systemFont(ofSize: 18))
                    let singleView = SingleView(frame: CGRect(x: 0, y: heightCounter, width: viewWidth, height: Int(height + 20)))
                    var isSelectedAnswer = false
                    if answer == i{
                        isSelectedAnswer = true
                    }
                    heightCounter += Int(height + 20)
                    singleView.setInfo(choice: choice, selected: isSelectedAnswer)
                    singleStackView.addSubview(singleView)
                    singleStackViewHeightConstraint.constant = CGFloat(heightCounter)
                }
            }
        }
    }
}
