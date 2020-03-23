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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        menuBackground.layer.cornerRadius = 12
        menuBackground.layer.borderWidth = 1
    }
    
    func setInfo(name: String){
        userNameLabel.text = name
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
    }
}
