//
//  OverviewViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-20.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

struct OverviewListItem {
    var question: Question
    var answer: Answer
}

class OverviewViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var overviewTableview: UITableView!
    
    
    var theAssignment: Assignment? = nil
    var questionsWithAnswers = [OverviewListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        overviewTableview.delegate = self
        overviewTableview.rowHeight = UITableView.automaticDimension
        overviewTableview.estimatedRowHeight = 60
        overviewTableview.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //showSurvey()
        if theAssignment != nil{
            for que in theAssignment!.survey.questions{
                if que.type != Type.header.rawValue &&
                    que.type != Type.footer.rawValue{
                    if let answers = theAssignment!.dataset?.answers{
                        if let answer = answers.first(where: {$0.index == que.index}){
                            questionsWithAnswers.append(OverviewListItem(question: que, answer: answer))
                        }
                    }
                }
            }
        }
        overviewTableview.reloadData()
    }
    
    /*func showSurvey(){
        if theAssignment != nil{
            let height: Int = 50
            for (i, question) in theAssignment!.survey.questions.enumerated() {
                let likertView = LikertView()
                likertView.frame = CGRect(x: 0, y: (height * i), width: Int(questionContainer.frame.width), height: height)
                likertView.setInfo(question: question)
                questionContainer.addSubview(likertView)
            }

            questionContainerHeightConstraint.constant = CGFloat(theAssignment!.survey.questions.count * height)
        }
    }*/
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OverviewViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsWithAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listObject = questionsWithAnswers[indexPath.row]
        switch questionsWithAnswers[indexPath.row].question.type {
            
        case Type.likertScales.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "likert", for: indexPath)
            if let cell = cell as? OverviewLikertTableViewCell{
                cell.setValues(item: listObject)
            }
            return cell
        case Type.multipleChoice.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "likert", for: indexPath)
            if let cell = cell as? OverviewLikertTableViewCell{
                cell.setValues(item: listObject)
            }
            return cell
        case Type.singleMultipleAnswers.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "single", for: indexPath)
            if let cell = cell as? OverviewSingleTableViewCell{
                cell.setValues(item: listObject)
            }
            return cell
        case Type.timeDuration.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "duration", for: indexPath)
            if let cell = cell as? OverviewDurationTableViewCell{
                cell.setValues(item: listObject)
            }
            return cell
        case Type.openEndedTextResponses.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "likert", for: indexPath)
            if let cell = cell as? OverviewLikertTableViewCell{
                cell.setValues(item: listObject)
            }
            return cell
        case Type.fillInTheBlank.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "likert", for: indexPath)
            if let cell = cell as? OverviewLikertTableViewCell{
                cell.setValues(item: listObject)
            }
            return cell
        case Type.footer.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "likert", for: indexPath)
            if let cell = cell as? OverviewLikertTableViewCell{
                cell.setValues(item: listObject)
            }
            return cell
        default://header
            let cell = tableView.dequeueReusableCell(withIdentifier: "likert", for: indexPath)
            if let cell = cell as? OverviewLikertTableViewCell{
                cell.setValues(item: listObject)
            }
            return cell
        }
        
    }
    
    
}
