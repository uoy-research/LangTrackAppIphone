//
//  SideMenu.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-23.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class SideMenu: UIViewController {
    
    @IBOutlet weak var menuBackground: UIView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    var listener: MenuListener?

    override func viewDidLoad() {
        super.viewDidLoad()

        menuBackground.layer.cornerRadius = 12
        menuBackground.layer.borderWidth = 2
        menuBackground.layer.borderColor = UIColor(named: "lta_blue")?.cgColor
    }
    
    func setInfo(name: String, listener: MenuListener){
        self.listener = listener
        userNameLabel.text = name
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        listener?.logOutSelected()
    }
    
    @IBAction func contactButtonPressed(_ sender: Any) {
        listener?.contact()
    }
    
    @IBAction func aboutButtonPressed(_ sender: Any) {
        listener?.about()
    }
    
    @IBAction func instructionsButtonPressed(_ sender: Any) {
        listener?.instructions()
    }
    
    @IBAction func testingSwitch(_ sender: UISwitch) {
        listener?.setTestMode(to: sender.isOn)
    }
}
