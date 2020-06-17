//
//  SideMenu.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-23.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit
import Charts

let attributeLtaBlueHeaderText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold),
                                   NSAttributedString.Key.foregroundColor: UIColor(named: "lta_blue") ?? UIColor.blue ]

let attributeLtaRedHeaderText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                   NSAttributedString.Key.foregroundColor: UIColor(named: "lta_red") ?? UIColor.red ]

let attributeLtaBlueText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                             NSAttributedString.Key.foregroundColor: UIColor(named: "lta_blue") ?? UIColor.blue ]

let attributeSmallText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]

class SideMenu: UIViewController {
    
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var versionInfoLabel: UILabel!
    @IBOutlet weak var testViewBottomConstraint: NSLayoutConstraint!
    
    var listener: MenuListener?

    override func viewDidLoad() {
        super.viewDidLoad()

        menuBackground.layer.cornerRadius = 12
        menuBackground.layer.borderWidth = 2
        menuBackground.layer.borderColor = UIColor(named: "lta_blue")?.cgColor
        
        let version = UIApplication.appVersion
        if version != nil{
            versionInfoLabel.text = "Version \(version ?? "")"
        }else{
            versionInfoLabel.text = ""
        }
        instructionsButton.setTitle(translatedInstructions, for: .normal)
    }
    
    func setTestView(userName: String){
        if  userName == "stephan" ||
            userName == "josef" ||
            userName == "marianne" ||
            userName == "jonas" ||
            userName == "henriette"  {
            testViewBottomConstraint.constant = 10
            testView.isHidden = false
        }else{
            testView.isHidden = true
            testViewBottomConstraint.constant = -testView.frame.height
        }
    }
    
    func setInfo(name: String, listener: MenuListener){
        self.listener = listener
        userNameLabel.text = name
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        listener?.logOutSelected()
    }
    
    @IBAction func testingSwitch(_ sender: UISwitch) {
        listener?.setTestMode(to: sender.isOn)
    }
}
