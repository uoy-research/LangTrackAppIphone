//
//  InstructionsViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var theScrollview: UIScrollView!
    
    var showingTopShadow = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view1.layer.cornerRadius = 12
        view1.setLabelShadow()
        view2.layer.cornerRadius = 12
        view2.setLabelShadow()
        view3.layer.cornerRadius = 12
        view3.setLabelShadow()
        view4.layer.cornerRadius = 12
        view4.setLabelShadow()
        view5.layer.cornerRadius = 12
        view5.setLabelShadow()
        
        theScrollview.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 5{
            if showingTopShadow == false{
                topView.setLabelShadow()
                showingTopShadow = true
            }
        }else{
            if showingTopShadow == true{
                topView.removeShadow()
                showingTopShadow = false
            }
        }
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
