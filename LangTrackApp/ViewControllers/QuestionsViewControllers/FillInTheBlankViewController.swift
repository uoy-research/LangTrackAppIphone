//
//  FillInTheBlankViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class FillInTheBlankViewController: UIViewController {

    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fillTableview: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var blankDescriptionLabel: UILabel!
    @IBOutlet weak var selectedWordContainer: UIView!
    
    var listener: QuestionListener?
    var theQuestion = Question()
    var dropDownOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8
        tableviewHeightConstraint.constant = 0
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.selectedWordTouched))
        selectedWordContainer.addGestureRecognizer(touch)
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        questionTextLabel.text = theQuestion.text
        blankDescriptionLabel.text = "Välj ord i listan"
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    
    func openProjectDropDown(){
        var dropDownHeight = CGFloat(50 * (self.theQuestion.fillBlanksChoises?.count ?? 0))
        if dropDownHeight > 190{
            dropDownHeight = 190
        }
        UIView.animate(withDuration: 0.3,animations: {
            self.tableviewHeightConstraint.constant = dropDownHeight
            self.view.layoutIfNeeded()
        }){_ in
            self.dropDownOpen = true
        }
    }
    
    func closeProjectDropDown(){
        UIView.animate(withDuration: 0.3, animations:  {
            self.tableviewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }){_ in
            self.dropDownOpen = false
        }
    }
    
    @objc func selectedWordTouched(sender: UITapGestureRecognizer){
        if dropDownOpen{
            closeProjectDropDown()
        }else{
            openProjectDropDown()
        }
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        listener?.previousQuestion(current: theQuestion)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        listener?.nextQuestion(current: theQuestion)
    }
    
}

extension FillInTheBlankViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fillCell", for: indexPath)
        if let cell = cell as? FillInBlankCell{
            cell.theText.text = "rad \(indexPath.row)"
        }
        return cell
    }
    
    
}

class FillInBlankCell: UITableViewCell {
    
    @IBOutlet weak var theText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
