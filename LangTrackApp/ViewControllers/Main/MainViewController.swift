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
    @IBOutlet weak var emptyListInfoLabel: UILabel!
    
    //var surveyList = [Survey]()
    //var selectedSurvey: Survey?
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
    var inTestMode = false
    
    //static let newNotification = NSNotification.Name(rawValue: "newNotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to update list everytime app enters foreground
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
        object: nil)
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
    
    @objc func willEnterForeground() {
       
       updateAssignments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil {
            performSegue(withIdentifier: "login", sender: nil)
        }else{
            if self.idTokenChangeListener == nil{
                setIdTokenListener()
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
        if Auth.auth().currentUser != nil{
            updateAssignments()
        }
    }
    
    func hideOrShowEmptyListInfo(){
        if SurveyRepository.assignmentList.isEmpty{
            emptyListInfoLabel.isHidden = false
            emptyListInfoLabel.text = translatedHereItWasEmpty
        }else{
            emptyListInfoLabel.isHidden = true
            emptyListInfoLabel.text = ""
        }
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
        sideMenu?.setTestView(userName: username ?? "")
        SurveyRepository.theUser = User(userName: username ?? "noName", mail: Auth.auth().currentUser?.email ?? "noMail")
        updateAssignments()
        sideMenu?.setInfo(name: SurveyRepository.theUser!.userName, listener: self)
        theTableView.reloadData()
        self.sideMenu?.setUserCharts()
    }
    
    func updateAssignments(){
        SurveyRepository.apiIsAlive { (alive) in
            if alive {
                SurveyRepository.getSurveys() { (assignments) in
                    if assignments != nil{
                        DispatchQueue.main.async {
                            self.theTableView.reloadData()
                            self.sideMenu?.setUserCharts()
                        }
                    }else{
                        self.showServerErrorMessage()
                    }
                    DispatchQueue.main.async {
                        self.hideOrShowEmptyListInfo()
                    }
                    self.setBadge()
                }
            }else{
                self.showServerErrorMessage()
            }
        }
        hideOrShowEmptyListInfo()
    }
    
    
    
    func showServerErrorMessage(){
        DispatchQueue.main.async {
            self.showToast(message: translatedNoContactWithServer, font: UIFont.systemFont(ofSize: 18))
        }
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
            dest.theUser = SurveyRepository.theUser
        }else if segue.identifier == "login"{
            let dest = segue.destination as! LoginViewController
            dest.modalPresentationStyle = .fullScreen
        }else if segue.identifier == "overview"{
            let dest = segue.destination as! OverviewViewController
            //dest.modalPresentationStyle = .fullScreen
            dest.theAssignment = SurveyRepository.selectedAssignment
        }
    }
    
    //MARK:- Actions
    
    //when pull to refresh
    @objc private func refreshListData(_ sender: Any) {
        SurveyRepository.apiIsAlive { (alive) in
            if alive{
                SurveyRepository.getSurveys() { (assignments) in
                    DispatchQueue.main.async {
                        self.pullControl.endRefreshing()
                    }
                    if assignments != nil{
                        DispatchQueue.main.async {
                            //self.surveyList = self.sortSurveyList(theList: surveys!)
                            self.theTableView.reloadData()
                            self.sideMenu?.setUserCharts()
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.pullControl.endRefreshing()
                        }
                        self.showServerErrorMessage()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.pullControl.endRefreshing()
                }
                self.showServerErrorMessage()
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
    
    func setBadge(){
        var numberOfActive = 0
        for assignment in SurveyRepository.assignmentList {
            let now = Date()
            let expiary = DateParser.getDate(dateString: assignment.expiry) ?? now
            if assignment.dataset == nil{
                if now < expiary{
                    //assigmnent is active
                    numberOfActive += 1
                }else{
                    //assignment is NOT active
                }
            }else{
                //assignment is NOT active
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = numberOfActive
        }
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
        
        if inTestMode{
            // in testmode - show survey
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "survey", sender: nil)
            }
        }else{
            if clickedCell is SurveyTableViewCell{
                
                if SurveyRepository.selectedAssignment?.dataset == nil{
                    // contains no answer - show popup
                    
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "unansweredPopup") as! UnansweredPopupViewController
                    
                    self.addChild(popOverVC)
                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParent: self)
                    
                }else{
                    DispatchQueue.main.async {
                        // contains answer - show overview
                        self.performSegue(withIdentifier: "overview", sender: nil)
                        //self.performSegue(withIdentifier: "survey", sender: nil)//TODO: remove
                    }
                }
            }else if clickedCell is CallToActionTableViewCell{
                SurveyRepository.apiIsAlive { (alive) in
                    if alive{
                        // is active - show survey
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "survey", sender: nil)
                        }
                    }else{
                        self.showServerErrorMessage()
                    }
                }
            }
        }
        
    }
}

//MARK:- CellTimerListener
extension MainViewController: CellTimerListener{
    func timerExpiered() {
        print("ViewController: CellTimerListener timerExpiered")
        theTableView.reloadData()
        setBadge()
    }
}

//MARK:- MenuListener
extension MainViewController: MenuListener{
    func setTestMode(to: Bool) {
        self.inTestMode = to
    }
    
    func logOutSelected() {
        let firebaseAuth = Auth.auth()
        if firebaseAuth.currentUser != nil{
            var username = firebaseAuth.currentUser?.email
            username!.until("@")
            
            DispatchQueue.main.async {
                let popup = UIAlertController(title: translatedLogOut, message: "\(translatedDoYouWantToLogOut)\n\(username ?? "")", preferredStyle: .alert)
                popup.addAction(UIAlertAction(title: translatedLogOut, style: .destructive, handler:{alert -> Void in
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
                popup.addAction(UIAlertAction(title: translatedCancel, style: .cancel, handler: nil))
                
                self.present(popup, animated: true, completion: nil)
            }
        }
    }
}
