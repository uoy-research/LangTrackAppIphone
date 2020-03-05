//
//  ViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-01-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//
//tidigare bundle identifier se.lu.humlab.LangTrackApp
//
// test1@humlablu.com
// 123456

// deltagare1a2b3c@humlablu.com
// 123456
/*
 När användaren öppnar appen - GET surveys
 fixa och visa svarade/osvarade/utgångna/ osv i listan
 
 info: testsurvey från dropbox med 7 questions är ca 2000 bytes
*/
/*TODO:
 *Hämta telefonens tidszoon och spara i settings för appen
 skicka med token från firebase i header /refreshtoken
 *skapa survey som Json och läs in som objekt
 *lägga json fil någonstans och hämta med http GET
 *FIXA iTunes connect!!!!!
 Koppla push och hantera i appen
 
 länk till filen på dropbox: https://www.dropbox.com/s/2w7cnliiow0st3d/survey_json.txt?dl=1
 survey = enkät
 answer = enkätsvar
 
 om ändrad AppleID eller bundleID: pod deintegrate -> pod install -> Starta om med ny workspace
 */

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
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    var latestFetchMilli: Int64 = 0
    
    static let newNotification = NSNotification.Name(rawValue: "newNotification")
    
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
        
        print("secondsFromGMT: \(secondsFromGMT)")
        print("localTimeZoneAbbreviation: \(localTimeZoneAbbreviation)")
        print("localTimeZoneIdentifier: \(localTimeZoneIdentifier)")
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(ViewController.receivedNewNotification(_:)),
        name: ViewController.newNotification,
        object: self)
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
    
    @objc func receivedNewNotification(_ aps: Notification) {
        
        // here is the aps if app is running
        // or if user clicked notification to start app
        print("receivedNewNotification: \(aps)")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "login", sender: nil)
        }else{
            // the user is logged in
            // if less than 5 min ago - dont fetch
            if latestFetchMilli + (1000 * 60 * 5) < Date().millisecondsSince1970{
                if let token = Auth.auth().currentUser?.refreshToken{
                    print("Fetching new surveys")
                    JsonHelper.getSurveys(token: token) { (surveys) in
                        if surveys != nil{
                            DispatchQueue.main.async {
                                self.surveyList = surveys!
                                self.theTableView.reloadData()
                            }
                        }
                    }
                }
                latestFetchMilli = Date().millisecondsSince1970
            }
            var username = Auth.auth().currentUser?.email
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

//MARK:- Tableview extension

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        surveyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSurvey = surveyList[indexPath.row]
        var isNil = true
        for a in currentSurvey.answer{
            if a.value.isAllNil(){
                isNil = false
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "surveyCell", for: indexPath)//callToActionCell
        cell.selectionStyle = .none
        if let cell = cell as? SurveyTableViewCell{
            cell.setSurveyInfo(survey: currentSurvey)
        }else{
            print("no cell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you selected \(indexPath.row)")
        selectedSurvey = surveyList[indexPath.row]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "survey", sender: nil)
        }
        /*let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "surveyContainer") as! SurveyViewController
        newViewController.theSurvey = surveyList[indexPath.row]
        newViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newViewController, animated: true)*/
    }
}
