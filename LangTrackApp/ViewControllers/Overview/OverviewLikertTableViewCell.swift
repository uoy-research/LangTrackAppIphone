//
//  OverviewLikertTableViewCell.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-07.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class OverviewLikertTableViewCell: UITableViewCell {

    @IBOutlet weak var likert0: UIView!
    @IBOutlet weak var likert1: UIView!
    @IBOutlet weak var likert2: UIView!
    @IBOutlet weak var likert3: UIView!
    @IBOutlet weak var likert4: UIView!
    @IBOutlet weak var likertTextLabel: UILabel!
    @IBOutlet weak var likertMinLabel: UILabel!
    @IBOutlet weak var likertMaxLabel: UILabel!
    
    var question: Question?
    var answer : Answer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        likert0.layer.cornerRadius = likert0.frame.width / 2
        likert1.layer.cornerRadius = likert1.frame.width / 2
        likert2.layer.cornerRadius = likert2.frame.width / 2
        likert3.layer.cornerRadius = likert3.frame.width / 2
        likert4.layer.cornerRadius = likert4.frame.width / 2
        likert0.layer.borderWidth = 0.5
        likert1.layer.borderWidth = 0.5
        likert2.layer.borderWidth = 0.5
        likert3.layer.borderWidth = 0.5
        likert4.layer.borderWidth = 0.5
        likert0.backgroundColor = UIColor.white
        likert1.backgroundColor = UIColor.white
        likert2.backgroundColor = UIColor.white
        likert3.backgroundColor = UIColor.white
        likert4.backgroundColor = UIColor.white
    }
    
    func setValues(item: OverviewListItem?){
        self.question = item?.question
        self.answer = item?.answer
        setLikertScale()
        likertTextLabel.text = question?.text
        likertMinLabel.text = question?.likertMin
        likertMaxLabel.text = question?.likertMax
    }
    
    func setAllUnmarked(){
        likert0.backgroundColor = UIColor.white
        likert1.backgroundColor = UIColor.white
        likert2.backgroundColor = UIColor.white
        likert3.backgroundColor = UIColor.white
        likert4.backgroundColor = UIColor.white
    }
    
    func setLikertScale(){
        if answer != nil{
            if answer!.likertAnswer != nil{
                switch answer!.likertAnswer! {
                case 0:
                    setAllUnmarked()
                    likert0.backgroundColor = UIColor(named: "lta_blue") ?? UIColor.blue
                case 1:
                    setAllUnmarked()
                    likert1.backgroundColor = UIColor(named: "lta_blue") ?? UIColor.blue
                case 2:
                    setAllUnmarked()
                    likert2.backgroundColor = UIColor(named: "lta_blue") ?? UIColor.blue
                case 3:
                    setAllUnmarked()
                    likert3.backgroundColor = UIColor(named: "lta_blue") ?? UIColor.blue
                case 4:
                    setAllUnmarked()
                    likert4.backgroundColor = UIColor(named: "lta_blue") ?? UIColor.blue
                default:
                    setAllUnmarked()
                }
            }else{
                setAllUnmarked()
            }
        }else{
            setAllUnmarked()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
