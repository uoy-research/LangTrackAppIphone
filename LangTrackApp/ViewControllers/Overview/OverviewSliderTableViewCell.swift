//
//  OverviewSliderTableViewCell.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2021-03-15.
//  Copyright © 2021 Stephan Björck. All rights reserved.
//

import UIKit

class OverviewSliderTableViewCell: UITableViewCell {

    @IBOutlet weak var sliderTextLabel: UILabel!
    @IBOutlet weak var theSlider: UISlider!
    @IBOutlet weak var naButton: LikertRadioButton!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var sliderLabel: UILabel!
    
    var question: Question?
    var answer : Answer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValues(item: OverviewListItem?){
        self.question = item?.question
        self.answer = item?.answer
        self.sliderTextLabel.text = question?.text ?? ""
        
        minLabel.text = question?.likertMin
        maxLabel.text = question?.likertMax
        
        let theSliderAnswer = self.answer?.sliderScaleAnswer ?? 0
        if theSliderAnswer == -1{
            naButton.isSelected = true
            sliderLabel.text = ""
            theSlider.value = Float(0)
        }else{
            naButton.isSelected = false
            sliderLabel.text = "\(theSliderAnswer)"
            theSlider.value = Float(theSliderAnswer)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
