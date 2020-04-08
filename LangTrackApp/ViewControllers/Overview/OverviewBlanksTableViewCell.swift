//
//  OverviewBlanksTableViewCell.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-08.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class OverviewBlanksTableViewCell: UITableViewCell {

    @IBOutlet weak var blanksTextLabel: UILabel!
    @IBOutlet weak var blanksChoicecContainer: UIView!
    @IBOutlet weak var blanksChoicecContainerHeightConstraint: NSLayoutConstraint!
    
    var question: Question?
    var answer : Answer?
    var theSentence: FillInWordSentence? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(item: OverviewListItem?){
        question = item?.question
        answer = item?.answer
        getTextAsList()
        if (theSentence != nil){
            setSentence()
            fillWordContainer()
        }
    }
    
    func fillWordContainer(){
        let selectedWord = theSentence!.listWithWords[theSentence!.indexForMissingWord]
        let width = Int(blanksChoicecContainer.frame.width - 50)
        let height = 25
        for (i, word) in question!.fillBlanksChoises!.enumerated(){
            let text = UILabel(frame: CGRect(x: 50, y: i * height, width: width, height: height))
            text.text = word
            if word == selectedWord{
                text.textColor = UIColor(named: "lta_blue") ?? UIColor.blue
                text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            }else{
                text.textColor = UIColor.black
                text.font = UIFont.systemFont(ofSize: 18, weight: .thin)
            }
            blanksChoicecContainer.addSubview(text)
            blanksChoicecContainerHeightConstraint.constant = CGFloat(height * (i + 1))
        }
    }

    func getTextAsList(){
        let arrayWithWords = question!.text.components(separatedBy: " ")
        if !arrayWithWords.isEmpty{
            var ind = -99
            for (i,word) in arrayWithWords.enumerated() {
                 #warning ("TODO: Handle when missing word is last with dot direct after")
                if word == "_____" || word == "_____."{
                    ind = i
                }
            }
            theSentence = FillInWordSentence()
            theSentence?.listWithWords = arrayWithWords
            theSentence?.indexForMissingWord = ind
        }
    }
    func underLineText(text: String)-> NSMutableAttributedString{
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSMutableAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedText.length))
        return attributedText
    }
    
    func setSentence(){
        let theAttributedSentence = NSMutableAttributedString()
        if answer != nil && answer?.fillBlankAnswer != nil && question != nil{
            if answer!.index == question!.index{
                // show previous answer
                let selectedWord = question!.fillBlanksChoises?[answer!.fillBlankAnswer!] ?? "_____"
                theSentence!.listWithWords[theSentence!.indexForMissingWord] = selectedWord
                //selectedWordLabel.text = selectedWord
                
                
                if selectedWord != "_____"{
                    for word in theSentence!.listWithWords{
                        if word == selectedWord{
                            //underline and add word
                            theAttributedSentence.append(underLineText(text: word))
                        }else{
                            //just add word
                            theAttributedSentence.append(NSAttributedString(string: word))
                        }
                        
                        if word != theSentence!.listWithWords.last{
                            theAttributedSentence.append(NSAttributedString(string: " "))
                        }
                    }
                }
            }
        }
        if theAttributedSentence.string == ""{
            //no choice selected - show org
            blanksTextLabel.text = theSentence?.listWithWords.joined(separator: " ")
        }else{
            //choice made - show
            blanksTextLabel.text = ""
            blanksTextLabel.attributedText = theAttributedSentence
        }
        
    }
}
