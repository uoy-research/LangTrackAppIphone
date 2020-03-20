//
//  OverviewViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-03-20.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    
    var theAssignment: Assignment? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        testLabel.text = theAssignment?.survey.title
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
