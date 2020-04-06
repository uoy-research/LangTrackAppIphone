//
//  MultipleChoiceViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class MultipleChoiceViewController: UIViewController {
    
    @IBOutlet weak var nextButton: NextButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var multiTableView: SelfSizedTableView!
    @IBOutlet weak var theIcon: UIImageView!
    @IBOutlet weak var tableviewContainer: UIView!
    
    var listener: QuestionListener?
    var theQuestion = Question()
    var theAnswer: Answer?
    var selectedAnswers = [Int]()
    let fontInCell = UIFont.systemFont(ofSize: 19)
    var cellWidth: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8
        theIcon.clipsToBounds = false
        theIcon.setSmallViewShadow()
        multiTableView.delegate = self
        multiTableView.rowHeight = UITableView.automaticDimension
        multiTableView.estimatedRowHeight = 60
        multiTableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        multiTableView.maxHeight = tableviewContainer.frame.height
        multiTableView.reloadData()
    }
    
    func setInfo(question: Question){
        self.theQuestion = question
        setTableviewWidth()
        nextButton.setEnabled(enabled: false)
        setSelectedAnswer()
        multiTableView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    func setListener(listener: QuestionListener) {
        self.listener = listener
    }
    
    func setSelectedAnswer(){
        if theAnswer != nil {
            if theAnswer?.index == theQuestion.index{
                if theAnswer!.multipleChoiceAnswer != nil{
                    selectedAnswers = theAnswer!.multipleChoiceAnswer!
                    nextButton.setEnabled(enabled: true)
                }
            }
        }
    }
    
    func setTableviewWidth(){
        let longest = theQuestion.multipleChoisesAnswers?.sorted(by: {$0.count > $1.count}).first
        let longestWidth = (longest?.width(withConstrainedHeight: 21, font: UIFont.systemFont(ofSize: 18, weight: .regular)) ?? 0) + 100
        print("tableviewContainer.frame.width: \(tableviewContainer.frame.width)")
        print("longestWidth: \(longestWidth)")
        print("cellWidth: \(cellWidth)")
        if longestWidth > tableviewContainer.frame.width{
            cellWidth = tableviewContainer.frame.width - 25
        }else{
            cellWidth = longestWidth
        }
    }
    
    func saveAnswers(){
        listener?.setMultipleAnswersAnswer(selected: selectedAnswers)
    }

    @IBAction func previousButtonPressed(_ sender: Any) {
        saveAnswers()
        selectedAnswers.removeAll()
        listener?.previousQuestion(current: theQuestion)
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        saveAnswers()
        selectedAnswers.removeAll()
        listener?.nextQuestion(current: theQuestion)
    }
}

extension MultipleChoiceViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theQuestion.multipleChoisesAnswers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "multi", for: indexPath)
        
        if let cell = cell as? MultiItemTableViewCell{
            
            cell.choiceLabel.text = theQuestion.multipleChoisesAnswers?[indexPath.row]
            cell.choiceLabel.font = fontInCell
            cell.checkBox.bgColorSelected = UIColor(named: "lta_blue") ?? .black
            cell.checkBox.color = .white
            cell.checkBox.borderWidth = 1.5
            cell.tag = indexPath.row
            cell.selectionStyle = .none
            if selectedAnswers.contains(indexPath.row){
                cell.setCheck(enabled: true)
                nextButton.setEnabled(enabled: true)
            }else{
                cell.setCheck(enabled: false)
            }
            cell.cellWithConstraint.constant = self.cellWidth
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !selectedAnswers.contains(indexPath.row){
            selectedAnswers.append(indexPath.row)
        }else{
            selectedAnswers.removeAll(where: {$0 == indexPath.row})
        }
        if selectedAnswers.isEmpty{
            self.nextButton.setEnabled(enabled: false)
        }else{
            self.nextButton.setEnabled(enabled: true)
        }
        multiTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let theTitle = theQuestion.text
        let s = theTitle.height(withConstrainedWidth: multiTableView.frame.width - 10, font: UIFont.systemFont(ofSize: 20, weight: .medium)) + 15
        return s
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tempLabel = UILabel()
        tempLabel.numberOfLines = 0
        tempLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        tempLabel.textAlignment = .center
        tempLabel.contentMode = .top
        tempLabel.text = theQuestion.text
        tempLabel.backgroundColor = UIColor.white

        return tempLabel
    }
    
}
