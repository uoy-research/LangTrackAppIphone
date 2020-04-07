//
//  SingleMultipleAnswersViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class SingleMultipleAnswersViewController: UIViewController {

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: NextButton!
    @IBOutlet weak var theIcon: UIImageView!
    @IBOutlet weak var singleTableView: SelfSizedTableView!
    @IBOutlet weak var tableviewContainer: UIView!
    
    
    var selectedAnswer = -99
    var listener: QuestionListener?
    var theQuestion = Question()
    var theAnswer: Answer?
    let fontInCell = UIFont.systemFont(ofSize: 18)
    var cellWidth: CGFloat = 100
    
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
        singleTableView.maxHeight = tableviewContainer.frame.height
        singleTableView.reloadData()
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        setTableviewWidth()
        nextButton.setEnabled(enabled: false)
        setSelectedAnswer()
        singleTableView.reloadData()
        self.view.layoutIfNeeded()
        setTableviewWidth()
        singleTableView.reloadData()
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
    
    func setTableviewWidth(){
        let longest = theQuestion.singleMultipleAnswers?.sorted(by: {$0.count > $1.count}).first
        let longestWidth = (longest?.width(withConstrainedHeight: 21, font: UIFont.systemFont(ofSize: 18, weight: .regular)) ?? 0) + 100
        if longestWidth > tableviewContainer.frame.width{
            cellWidth = tableviewContainer.frame.width - 25
        }else{
            cellWidth = longestWidth
        }
    }
    
    func saveAnswer(){
        if selectedAnswer != -99{
            listener?.setSingleMultipleAnswer(selected: selectedAnswer)
        }
    }
    
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
            cell.cellWidthConstraint.constant = self.cellWidth
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswer = indexPath.row
        self.nextButton.setEnabled(enabled: true)
        singleTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let theTitle = theQuestion.text
        let s = theTitle.height(withConstrainedWidth: singleTableView.frame.width - 10, font: UIFont.systemFont(ofSize: 20, weight: .medium)) + 15
        return s
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UILabel()
        vw.numberOfLines = 0
        vw.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        vw.textAlignment = .center
        vw.contentMode = .top
        vw.text = theQuestion.text
        vw.backgroundColor = UIColor.white

        return vw
    }
}
