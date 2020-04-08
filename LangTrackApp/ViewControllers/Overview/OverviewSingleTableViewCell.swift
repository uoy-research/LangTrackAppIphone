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
    
    func setValues(item: OverviewListItem?, single: Bool){
        self.question = item?.question
        self.answer = item?.answer
        if single {
            let selectedChoice = self.answer?.singleMultipleAnswer
            fillAnswers(answer: selectedChoice ?? -99)
        }else{
            let selectedChoices = self.answer?.multipleChoiceAnswer
            fillAnswersMulti(answer: selectedChoices ?? [])
        }
        singleTextLabel.text = item?.question.text
    }
    
    func emptyStackView(){
        for v in singleStackView.subviews{
            v.removeFromSuperview()
        }
    }
    
    func fillAnswers(answer: Int){
        emptyStackView()
        if question != nil{
            if question!.singleMultipleAnswers != nil{
                let viewWidth = Int((singleStackView.frame.width) - 5)
                var heightCounter = 0
                for (i, choice) in question!.singleMultipleAnswers!.enumerated() {
                    let height = choice.height(withConstrainedWidth: CGFloat(viewWidth - 30), font: UIFont.systemFont(ofSize: 19))
                    let singleView = SingleView(frame: CGRect(x: 0, y: heightCounter, width: viewWidth, height: Int(height + 20)))
                    var isSelectedAnswer = false
                    if answer == i{
                        isSelectedAnswer = true
                    }
                    heightCounter += Int(height + 20)
                    singleView.setInfo(choice: choice, selected: isSelectedAnswer, single: true)
                    singleStackView.addSubview(singleView)
                    singleStackViewHeightConstraint.constant = CGFloat(heightCounter)
                }
            }
        }
    }
    
    func fillAnswersMulti(answer: [Int]){
        emptyStackView()
        if question != nil{
            if question!.multipleChoisesAnswers != nil{
                let viewWidth = Int((singleStackView.frame.width) - 20)
                var heightCounter = 0
                for (i, choice) in question!.multipleChoisesAnswers!.enumerated() {
                    let height = choice.height(withConstrainedWidth: CGFloat(viewWidth - 30), font: UIFont.systemFont(ofSize: 19))
                    let singleView = SingleView(frame: CGRect(x: 0, y: heightCounter, width: viewWidth, height: Int(height + 20)))
                    var isSelectedAnswer = false
                    if answer.contains(i){
                        isSelectedAnswer = true
                    }
                    heightCounter += Int(height + 20)
                    singleView.setInfo(choice: choice, selected: isSelectedAnswer, single: false)
                    singleStackView.addSubview(singleView)
                    singleStackViewHeightConstraint.constant = CGFloat(heightCounter)
                }
            }
        }
    }
}
