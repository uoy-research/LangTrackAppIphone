//
//  ViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//
// test1@humlablu.com
// 123456

// deltagare1a2b3c@humlablu.com
// 123456

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var theTableView: UITableView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableviewContainer: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    var surveyList = [Survey]()
    var selectedSurvey: Survey?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTableView.rowHeight = UITableView.automaticDimension
        theTableView.estimatedRowHeight = 75
        theTableView.delegate = self
        theTableView.layer.cornerRadius = 8
        
        aboutButton.layer.cornerRadius = 8
        aboutButton.layer.borderWidth = 0.35
        aboutButton.layer.borderColor = UIColor.lightGray.cgColor
        
        instructionsButton.layer.cornerRadius = 8
        instructionsButton.layer.borderWidth = 0.35
        instructionsButton.layer.borderColor = UIColor.lightGray.cgColor
        
        contactButton.layer.cornerRadius = 8
        contactButton.layer.borderWidth = 0.35
        contactButton.layer.borderColor = UIColor.lightGray.cgColor
        
        surveyList.append(TestSurvey.getTempSurvey(number: "1", responded: false))
        surveyList.append(TestSurvey.getTempSurvey(number: "2", responded: true))
        surveyList.append(TestSurvey.getTempSurvey(number: "3", responded: true))
        surveyList.append(TestSurvey.getTempSurvey(number: "4", responded: true))
        surveyList.append(TestSurvey.getTempSurvey(number: "5", responded: true))
        surveyList.append(TestSurvey.getTempSurvey(number: "6", responded: true))
        surveyList.append(TestSurvey.getTempSurvey(number: "7", responded: true))
        surveyList.append(TestSurvey.getTempSurvey(number: "8", responded: true))
        theTableView.reloadData()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "login", sender: nil)
        }else{
            var username = Auth.auth().currentUser?.email
            username!.until("@")
            userNameLabel.text = "Inloggad som \(username!)"
        }
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            performSegue(withIdentifier: "login", sender: nil)
            //TODO: Töm listor osv
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        surveyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surveyCell", for: indexPath)
        cell.selectionStyle = .none
        if let cell = cell as? SurveyTableViewCell{
            cell.setSurveyInfo(survey: surveyList[indexPath.row])
        }else{
            print("no cell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSurvey = surveyList[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "surveyContainer") as! SurveyViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
}
