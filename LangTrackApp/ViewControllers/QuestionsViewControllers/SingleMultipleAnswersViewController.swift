//
//  SingleMultipleAnswersViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class SingleMultipleAnswersViewController: UIViewController {

    @IBOutlet weak var singleMultipleContainer: UIView!
    @IBOutlet weak var containerBackground: UIView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: NextButton!
    //@IBOutlet weak var singleMultipleTextLabel: UILabel!
    @IBOutlet weak var answersContainer: UIView!
    @IBOutlet weak var answersContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answersContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var theIcon: UIImageView!
    @IBOutlet weak var singleTableView: UITableView!
    @IBOutlet weak var singleMultipleTextView: UITextView!
    
    @IBOutlet weak var singleMultipleTextViewHeightConstraint: NSLayoutConstraint!
    
    
    var selectedAnswer = -99
    var listener: QuestionListener?
    var theQuestion = Question()
    var theAnswer: Answer?
    let fontInCell = UIFont.systemFont(ofSize: 19)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8
        theIcon.clipsToBounds = false
        theIcon.setSmallViewShadow()
        singleTableView.delegate = self
        singleTableView.rowHeight = UITableView.automaticDimension
        singleTableView.estimatedRowHeight = 60
        singleTableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setHeightAndWidthOfTableview()
        setHeightOfTextView()
    }
    
    func setHeightOfTextView(){
        let textheight = theQuestion.text.height(withConstrainedWidth: singleMultipleTextView.frame.width, font: UIFont.systemFont(ofSize: 20, weight: .medium)) + 40
        if textheight > 84{
            singleMultipleTextViewHeightConstraint.constant = 84//3 rows
        }else{
            singleMultipleTextViewHeightConstraint.constant = textheight
        }
    }
    
    func setHeightAndWidthOfTableview(){
        if theQuestion.singleMultipleAnswers != nil{
            var tableviewHeight: CGFloat = 0
            
            //width
            let longest = theQuestion.singleMultipleAnswers!.sorted(by: {$0.count > $1.count}).first ?? ""
            let longestTextSize = longest.width(withConstrainedHeight: 21, font: fontInCell) + 100
            
            if longestTextSize > containerBackground.frame.width{
                answersContainerWidthConstraint.constant = containerBackground.frame.width
            }else{
                answersContainerWidthConstraint.constant = longestTextSize
            }
            
            //height
            for (index, _) in theQuestion.singleMultipleAnswers!.enumerated() {
                if let theCell = singleTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SingleItemTableViewCell{
                    let cellHeight = theCell.choiceLabel.intrinsicContentSize.height + 36
                    tableviewHeight += cellHeight
                }
            }
            if tableviewHeight != 0{
                print("singleMultipleContainer.frame.height: \(singleMultipleContainer.frame.height)")
                print("tableviewHeight: \(tableviewHeight)")
                if tableviewHeight > (self.view.frame.height * 0.45){
                    answersContainerHeightConstraint.constant = self.view.frame.height * 0.44
                }else{
                    answersContainerHeightConstraint.constant = tableviewHeight
                }
            }
        }
    }
    
    
    func setInfo(question: Question){
        self.theQuestion = question
        singleMultipleTextView.text = theQuestion.text
        nextButton.setEnabled(enabled: false)
        setSelectedAnswer()
        singleTableView.reloadData()
        setHeightAndWidthOfTableview()
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    
    func setSelectedAnswer(){
        if theAnswer != nil {
            if theAnswer?.index == theQuestion.index{
                if theAnswer!.singleMultipleAnswer != nil{
                    selectedAnswer = theAnswer!.singleMultipleAnswer!
                    nextButton.setEnabled(enabled: true)
                }
            }
        }
    }
    
    /*func markSelectedAnswer(selected: Int){
        for v in answersContainer.subviews{
            if v is VKCheckbox{
                let check = v as! VKCheckbox
                if check.tag != selected{
                    check.setOn(false, animated: true)
                }
            }
        }
    }*/
    
    /*func getSelected() -> Int?{
        for v in answersContainer.subviews{
            if v is VKCheckbox{
                if (v as! VKCheckbox).isOn{
                    return v.tag
                }
            }
        }
        return nil
    }*/
    
    func saveAnswer(){
//        let answer = getSelected()
//        if answer != nil{
//            listener?.setSingleMultipleAnswer(selected: answer!)
//        }
        if selectedAnswer != -99{
            listener?.setSingleMultipleAnswer(selected: selectedAnswer)
        }
    }
    
    /*func emptyAnswers(){
        for v in answersContainer.subviews{
            v.removeFromSuperview()
        }
    }*/
    
    /*func fillAnswers(){
        emptyAnswers()
        if theQuestion.singleMultipleAnswers != nil{
            let spacer = 10
            let size = 29
            var maxIntrinsicWidth: CGFloat = 100
            for (i, answer) in theQuestion.singleMultipleAnswers!.enumerated() {
                let check = VKCheckbox(frame: CGRect(x: 0, y: ((size + spacer) * i), width: size, height: size))
                //check.bgColorSelected = .white
                check.bgColorSelected = UIColor(named: "lta_blue") ?? .black
                check.color = .white
                check.borderWidth = 1.5
                check.line = .thin
                check.cornerRadius = check.frame.width / 2
                check.tag = i
                if theAnswer != nil {
                    if theAnswer?.index == theQuestion.index{
                        if theAnswer!.singleMultipleAnswer != nil{
                            if check.tag == theAnswer!.singleMultipleAnswer!{
                                check.setOn(true)
                                nextButton.setEnabled(enabled: true)
                            }
                        }
                    }
                }
                check.checkboxValueChangedBlock = {
                    tag, ison in
                    if ison{
                        self.markSelectedAnswer(selected: tag)
                        self.nextButton.setEnabled(enabled: true)
                    }
                }
                let containerWidth = Int(containerBackground.frame.width * 0.92) - size - spacer
                let text = UILabel(frame: CGRect(x: size + spacer, y: ((size + spacer) * i), width: containerWidth, height: size))
                text.text = answer
                text.textAlignment = .left
                text.font = text.font.withSize(18)
                text.contentMode = .center
                text.numberOfLines = 0
                if text.intrinsicContentSize.width > maxIntrinsicWidth{
                    maxIntrinsicWidth = text.intrinsicContentSize.width
                }
                answersContainer.addSubview(check)
                answersContainer.addSubview(text)
                answersContainerHeightConstraint.constant = CGFloat((size + spacer) * (i+1))
            }
            if (maxIntrinsicWidth + CGFloat(size + spacer)) < containerBackground.frame.width{
                answersContainerWidthConstraint.constant = maxIntrinsicWidth + CGFloat(size + spacer)
            }else{
                answersContainerWidthConstraint.constant = containerBackground.frame.width
            }
        }
    }*/
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        saveAnswer()
        selectedAnswer = -99
        listener?.previousQuestion(current: theQuestion)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        saveAnswer()
        selectedAnswer = -99
        listener?.nextQuestion(current: theQuestion)
    }
    
}

extension SingleMultipleAnswersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theQuestion.singleMultipleAnswers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "single", for: indexPath)
        
        if let cell = cell as? SingleItemTableViewCell{
            cell.choiceLabel.text = theQuestion.singleMultipleAnswers?[indexPath.row]
            cell.choiceLabel.font = fontInCell
            cell.checkBox.bgColorSelected = UIColor(named: "lta_blue") ?? .black
            cell.checkBox.color = .white
            cell.checkBox.borderWidth = 1.5
            cell.checkBox.line = .thin
            cell.checkBox.cornerRadius = cell.checkBox.frame.width / 2
            cell.tag = indexPath.row
            cell.selectionStyle = .none
            if selectedAnswer == indexPath.row{
                cell.setCheck(enabled: true)
                nextButton.setEnabled(enabled: true)
            }else{
                cell.setCheck(enabled: false)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswer = indexPath.row
        self.nextButton.setEnabled(enabled: true)
        singleTableView.reloadData()
    }
    
    
}
