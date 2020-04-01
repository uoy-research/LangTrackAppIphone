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
 
 nytt repository
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

extension Notification.Name {
static let newNotification = Notification.Name("newNotification")
}

class MainViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var tableviewContainer: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var sideMenuContainer: UIView!
    @IBOutlet weak var sideMenuContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var sideMenuLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuDimBackground: UIView!
    
    //var surveyList = [Survey]()
    //var selectedSurvey: Survey?
    var theUser: User?
    //var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    //var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
    var localTimeZoneIdentifier: String { return TimeZone.current.identifier }
    var latestFetchMilli: Int64 = 0
    var idTokenChangeListener: IDTokenDidChangeListenerHandle?
    var menuOut: CGFloat = -250
    let menuIn: CGFloat = 0
    var menuIsShowing = false
    var sideMenu : SideMenu?
    private var pullControl = UIRefreshControl()
    
    //static let newNotification = NSNotification.Name(rawValue: "newNotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTableView.rowHeight = UITableView.automaticDimension
        theTableView.estimatedRowHeight = 175
        theTableView.delegate = self
        //pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            theTableView.refreshControl = pullControl
        } else {
            theTableView.addSubview(pullControl)
        }
//        theTableView.layer.cornerRadius = 8
        
        //print("secondsFromGMT: \(secondsFromGMT)")
        //print("localTimeZoneAbbreviation: \(localTimeZoneAbbreviation)")
        //print("localTimeZoneIdentifier: \(localTimeZoneIdentifier)")
        SurveyRepository.localTimeZoneIdentifier = localTimeZoneIdentifier
        
        /*NotificationCenter.default.addObserver(
        self,
        selector: #selector(ViewController.receivedNewNotification(_:)),
        name: .newNotification,
        object: self)*/
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedNewNotification(_:)), name: .newNotification, object: nil)
        
        if self.idTokenChangeListener == nil && Auth.auth().currentUser != nil{
            setIdTokenListener()
        }
        
        //Menu
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        sideMenuContainerWidthConstraint.constant = screenWidth / 1.5 //how far in sidemenu shows
        menuOut = -(sideMenuContainerWidthConstraint.constant)
        self.sideMenuLeftConstraint.constant = self.menuOut
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.clickOnBackground))
        menuDimBackground.addGestureRecognizer(gesture)
        menuDimBackground.alpha = 0
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sideMenu = (storyboard.instantiateViewController(withIdentifier: "sidemenu") as! SideMenu)
        //add menu
        self.addChild(sideMenu!)
        sideMenuContainer.addSubview(sideMenu!.view)
        sideMenu!.view.frame = sideMenuContainer.bounds
        sideMenu!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenu!.didMove(toParent: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "login", sender: nil)
        }else{
            if self.idTokenChangeListener == nil{
                setIdTokenListener()
            }
            // the user is logged in
            // if less than 5 min ago - dont fetch
            // -not working if logOut and logIn within 5 min-
            /*if latestFetchMilli + (1000 * 60 * 5) < Date().millisecondsSince1970{
                SurveyRepository.getSurveys() { (surveys) in
                    if surveys != nil{
                        DispatchQueue.main.async {
                            //self.surveyList = self.sortSurveyList(theList: surveys!)
                            self.theTableView.reloadData()
                        }
                    }
                }
                latestFetchMilli = Date().millisecondsSince1970
            }*/
            var username = Auth.auth().currentUser?.email
            username!.until("@")
            if username != nil{
                if username! != ""{
                    Messaging.messaging().subscribe(toTopic: username!) { error in
                        print("Messaging subscribed to \(username!)")
                    }
                }
            }
            fetchAssignmentsAndSetUserName()
        }
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        var startPointX: CGFloat = 0
        let frac = 1 - (sideMenuLeftConstraint.constant / menuOut)
        
        if gesture.state == .began{
            startPointX = translation.x
            menuDimBackground.isHidden = false
        }else if gesture.state == .ended{
            if frac < 0.5{
                
                // hide menu
                UIView.animate(withDuration: 0.25, animations: {
                    self.sideMenuLeftConstraint.constant = self.menuOut
                    self.menuDimBackground.alpha = 0
                    self.view.layoutIfNeeded()
                    self.menuButton.transform = CGAffineTransform(rotationAngle: 0)
                }){ _ in
                    self.menuDimBackground.isHidden = true
                    self.menuIsShowing = false
                }
                
            }else{
                // show menu
                UIView.animate(withDuration: 0.2, animations: {
                    self.sideMenuLeftConstraint.constant = self.menuIn
                    self.menuDimBackground.alpha = 0.5
                    self.view.layoutIfNeeded()
                    self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
                }){_ in
                    self.menuIsShowing = true
                }
            }
        } else if (translation.x > startPointX + 5) && menuIsShowing == false{
            // right
            sideMenuLeftConstraint.constant = menuOut + translation.x
            var dimValue = 0.5 * frac
            if(dimValue > 0.5){ dimValue = 0.5 }
            self.menuDimBackground.alpha = dimValue
            self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2) * frac)
        } else if (translation.x < startPointX - 5) && menuIsShowing == true{
            // left
            sideMenuLeftConstraint.constant = 0 + translation.x
            let dimValue = 0.5 * frac
            self.menuDimBackground.alpha = dimValue
            self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2) * frac)
        }
    }
    
    
    @objc func receivedNewNotification(_ aps: Notification) {
        
        // here is the aps if app is running
        // or if user clicked notification to start app
        print("receivedNewNotification")
        fetchAssignmentsAndSetUserName()
    }
    
    
    
    func setIdTokenListener(){
        self.idTokenChangeListener = Auth.auth().addIDTokenDidChangeListener() { (auth, user) in
            if let user = user {
                // Get the token, renewing it if the 60 minute expiration
                //  has occurred.
                user.getIDToken { idToken, error in
                    if let error = error {
                        // Handle error
                        print("getIDToken error: \(error)")
                        return;
                    }
                    //print("getIDToken token: \(String(describing: idToken))")
                    if idToken != nil{
                        SurveyRepository.setIdToken(token: idToken!)
                    }
                }
            }
        }
    }
    
    func fetchAssignmentsAndSetUserName(){
        var username = Auth.auth().currentUser?.email
        username!.until("@")
        SurveyRepository.userId = username ?? ""
        SurveyRepository.getSurveys() { (assignments) in
            if assignments != nil{
                DispatchQueue.main.async {
                    //self.surveyList = self.sortSurveyList(theList: surveys!)
                    self.theTableView.reloadData()
                }
            }
        }
        self.theUser = User(userName: username ?? "noName", mail: Auth.auth().currentUser?.email ?? "noMail")
        sideMenu?.setInfo(name: self.theUser!.userName, listener: self)
        theTableView.reloadData()
    }
    
    //MARK: Menu
    
    @objc func clickOnBackground(sender : UITapGestureRecognizer) {
        hideMenu()
    }
    
    func showMenu(){
        menuDimBackground.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuLeftConstraint.constant = self.menuIn
            self.menuDimBackground.alpha = 0.5
            self.view.layoutIfNeeded()
            self.menuButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        }){_ in
            self.menuIsShowing = true
        }
    }
    
    func hideMenu(){
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuLeftConstraint.constant = self.menuOut
                self.menuDimBackground.alpha = 0
                self.view.layoutIfNeeded()
                self.menuButton.transform = CGAffineTransform(rotationAngle: 0)
            }){ _ in
                self.menuDimBackground.isHidden = true
                self.menuIsShowing = false
            }
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "survey"{
            let dest = segue.destination as! SurveyViewController
            dest.modalPresentationStyle = .fullScreen
            //dest.theSurvey = SurveyRepository.selectedAssignment?.survey//selectedSurvey
            dest.theAssignment = SurveyRepository.selectedAssignment
            dest.theUser = self.theUser
        }else if segue.identifier == "login"{
            let dest = segue.destination as! LoginViewController
            dest.modalPresentationStyle = .fullScreen
        }else if segue.identifier == "overview"{
            let dest = segue.destination as! OverviewViewController
            dest.modalPresentationStyle = .fullScreen
            dest.theAssignment = SurveyRepository.selectedAssignment
        }
    }
    
    //MARK:- Actions
    
    @objc private func refreshListData(_ sender: Any) {
        SurveyRepository.getSurveys() { (assignments) in
            DispatchQueue.main.async {
                self.pullControl.endRefreshing()
            }
            if assignments != nil{
                DispatchQueue.main.async {
                    //self.surveyList = self.sortSurveyList(theList: surveys!)
                    self.theTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if(sideMenuLeftConstraint.constant == menuOut){
            showMenu()
        }else{
            hideMenu()
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
    }
}

//MARK:- Tableview extension

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //surveyList.count
        SurveyRepository.assignmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentAssignment = SurveyRepository.assignmentList[indexPath.row]
        let now = Date()
        let expiary = DateParser.getDate(dateString: currentAssignment.expiry) ?? now
        if currentAssignment.dataset == nil{
            if now < expiary{
                let cell = tableView.dequeueReusableCell(withIdentifier: "callToActionCell", for: indexPath)
                cell.selectionStyle = .none
                if let cell = cell as? CallToActionTableViewCell{
                    cell.setSurveyInfo(assignment: currentAssignment, tableviewHeight: theTableView.frame.height)
                    cell.setListener(theListener: self)
                }else{
                    print("no cell")
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "surveyCell", for: indexPath)
                cell.selectionStyle = .none
                if let cell = cell as? SurveyTableViewCell{
                    cell.setSurveyInfo(assignment: currentAssignment)
                }else{
                    print("no cell")
                }
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "surveyCell", for: indexPath)
            cell.selectionStyle = .none
            if let cell = cell as? SurveyTableViewCell{
                cell.setSurveyInfo(assignment: currentAssignment)
            }else{
                print("no cell")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SurveyRepository.selectedAssignment = SurveyRepository.assignmentList[indexPath.row]
        let clickedCell = tableView.cellForRow(at: indexPath)
        
        if clickedCell is SurveyTableViewCell{
            DispatchQueue.main.async {
                //self.performSegue(withIdentifier: "overview", sender: nil)
                self.performSegue(withIdentifier: "survey", sender: nil)//TODO: remove
            }
        }else if clickedCell is CallToActionTableViewCell{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "survey", sender: nil)
            }
        }
        
    }
}

//MARK:- CellTimerListener
extension MainViewController: CellTimerListener{
    func timerExpiered() {
        print("ViewController: CellTimerListener timerExpiered")
        theTableView.reloadData()
    }
}

//MARK:- MenuListener
extension MainViewController: MenuListener{
    func logOutSelected() {
        let firebaseAuth = Auth.auth()
        if firebaseAuth.currentUser != nil{
            var username = firebaseAuth.currentUser?.email
            username!.until("@")
            
            DispatchQueue.main.async {
                let popup = UIAlertController(title: "Logga ut", message: "Vill du logga ut?\n\(username ?? "")", preferredStyle: .alert)
                popup.addAction(UIAlertAction(title: "Logga ut", style: .destructive, handler:{alert -> Void in
                    do {
                        try firebaseAuth.signOut()
                        if username != nil{
                            if username! != ""{
                                Messaging.messaging().unsubscribe(fromTopic: username!)
                                { error in
                                    print("Messaging unsubscribed to \(username!)")
                                }
                            }
                        }
                        self.performSegue(withIdentifier: "login", sender: nil)
                        SurveyRepository.assignmentList = []
                        self.theTableView.reloadData()
                        // Remove the token ID listenter.
                        guard let tokenListener = self.idTokenChangeListener else { return }
                        Auth.auth().removeStateDidChangeListener(tokenListener)
                        self.idTokenChangeListener = nil
                        self.sideMenu?.userNameLabel.text = ""
                        self.hideMenu()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                }))
                popup.addAction(UIAlertAction(title: "Avbryt", style: .cancel, handler: nil))
                
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
    
    func instructions() {
        print("MenuListener instructions")
    }
    
    func contact() {
        print("MenuListener contact")
    }
    
    func about() {
        print("MenuListener about")
    }
    
    
}
