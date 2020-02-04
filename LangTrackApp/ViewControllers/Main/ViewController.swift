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

//TDO: Hämta telefonens tidszoon och spara i settings för appen
// skicka med token från firebase i header /refreshtoken

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
    var theUser: User?
    
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
        surveyList.append(TestSurvey.getTempSurveyWithOneQuestion(number: "med en fråga", responded: false))
        surveyList.append(TestSurvey.getTempSurveyWithThreeMixedQuestion(number: "med tre frågor", responded: true))
        theTableView.reloadData()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "login", sender: nil)
        }else{
            var username = Auth.auth().currentUser?.email
            print("Auth.auth().currentUser?: \(Auth.auth().currentUser?.refreshToken ?? "no tyoken" )")
            username!.until("@")
            self.theUser = User(userName: username ?? "noName", mail: Auth.auth().currentUser?.email ?? "noMail")
            userNameLabel.text = "Inloggad som \(self.theUser!.userName)"
        }
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        if firebaseAuth.currentUser != nil{
            var username = firebaseAuth.currentUser?.email
            username!.until("@")
            DispatchQueue.main.async {
                let popup = UIAlertController(title: "Logga ut", message: "Vill du logga ut?\n\(username ?? "")", preferredStyle: .alert)
                popup.addAction(UIAlertAction(title: "Logga ut", style: .destructive, handler:{alert -> Void in
                    do {
                        try firebaseAuth.signOut()
                        self.performSegue(withIdentifier: "login", sender: nil)
                        //TODO: Töm listor osv
                        self.userNameLabel.text = ""
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                }))
                popup.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
                
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "survey"{
            let dest = segue.destination as! SurveyViewController
            dest.modalPresentationStyle = .fullScreen
            dest.theSurvey = selectedSurvey
            dest.theUser = self.theUser
        }else if segue.identifier == "login"{
            let dest = segue.destination as! LoginViewController
            dest.modalPresentationStyle = .fullScreen
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
        performSegue(withIdentifier: "survey", sender: nil)
        /*let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "surveyContainer") as! SurveyViewController
        newViewController.theSurvey = surveyList[indexPath.row]
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)*/
    }
}
