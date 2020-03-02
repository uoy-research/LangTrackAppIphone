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
    @IBOutlet weak var selectedWordContainer: UIView!
    @IBOutlet weak var containerArrow: UILabel!
    
    var listener: QuestionListener?
    var theQuestion = Question()
    var dropDownOpen = false
    let radious:CGFloat = 8
    var arrowUp = false
    var rowheight: CGFloat = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.layer.cornerRadius = radious
        nextButton.layer.cornerRadius = radious
        tableviewHeightConstraint.constant = radious
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.selectedWordTouched))
        selectedWordContainer.addGestureRecognizer(touch)
        fillTableview.rowHeight = rowheight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if #available(iOS 11.0, *) {
            self.selectedWordContainer.clipsToBounds = true
            selectedWordContainer.layer.cornerRadius = radious
            selectedWordContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            self.fillTableview.clipsToBounds = true
            fillTableview.layer.cornerRadius = radious
            fillTableview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        questionTextLabel.text = theQuestion.text
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    
    func openProjectDropDown(){
        turnArrow()
        var dropDownHeight = CGFloat(Int(rowheight) * (self.theQuestion.fillBlanksChoises?.count ?? 0))
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
        turnArrow()
        UIView.animate(withDuration: 0.3, animations:  {
            self.tableviewHeightConstraint.constant = self.radious
            self.view.layoutIfNeeded()
        }){_ in
            self.dropDownOpen = false
        }
    }
    
    func turnArrow(){
        if arrowUp{
            UIView.animate(withDuration: 0.3, animations: {
                self.containerArrow.transform = CGAffineTransform(rotationAngle: 0)
                self.view.layoutIfNeeded()
            })
            arrowUp = false
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.containerArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                self.view.layoutIfNeeded()
            })
            arrowUp = true
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

//MARK:- TableViewDelegate
extension FillInTheBlankViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theQuestion.fillBlanksChoises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fillCell", for: indexPath)
        if let cell = cell as? FillInBlankCell{
            cell.theText.text = theQuestion.fillBlanksChoises?[indexPath.row] ?? ""
            cell.selectionStyle = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you selected \(theQuestion.fillBlanksChoises?[indexPath.row] ?? "")")
        closeProjectDropDown()
    }
}

//MARK:- FillInBlankCell class

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
