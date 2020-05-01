//
//  ContactViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var theScrollview: UIScrollView!
    
    @IBOutlet weak var ltaLinkLabel: UILabel!
    @IBOutlet weak var humLinkLabel: UILabel!
    @IBOutlet weak var luLinkLabel: UILabel!
    
    var showingTopShadow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        linkView.layer.cornerRadius = 12
        linkView.setLabelShadow()
        view2.layer.cornerRadius = 12
        view2.setLabelShadow()
        view3.layer.cornerRadius = 12
        view3.setLabelShadow()
        view4.layer.cornerRadius = 12
        view4.setLabelShadow()
        view5.layer.cornerRadius = 12
        view5.setLabelShadow()
        
        theScrollview.delegate = self
        
        ltaLinkLabel.makeUnderlinedTitle(title:"The Lang-Track-App project", fontSize: 20, color: "lta_blue")
        humLinkLabel.makeUnderlinedTitle(title:"Humanistlaboratoriet", fontSize: 20, color: "lta_blue")
        luLinkLabel.makeUnderlinedTitle(title:"Lunds Universitet", fontSize: 20, color: "lta_blue")
        
        let ltaListener = UITapGestureRecognizer(target: self, action: #selector(self.ltaClicked))
        ltaLinkLabel.addGestureRecognizer(ltaListener)
        
        let humLinkListener = UITapGestureRecognizer(target: self, action: #selector(self.humLinkClicked))
        humLinkLabel.addGestureRecognizer(humLinkListener)
        
        let luLinkListener = UITapGestureRecognizer(target: self, action: #selector(self.luLinkClicked))
        luLinkLabel.addGestureRecognizer(luLinkListener)
    }
    
    @objc func ltaClicked(sender: UITapGestureRecognizer){
        if let url = URL(string: "https://portal.research.lu.se/portal/en/projects/the-langtrackapp-studying-exposure-to-and-use-of-a-new-language-using-smartphone-technology(4e734940-981f-4dd0-841a-eb6ac760af0c).html"),
                UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
        }
    }
    @objc func humLinkClicked(sender: UITapGestureRecognizer){
        if let url = URL(string: "https://www.humlab.lu.se/en/"),
                UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
        }
    }
    @objc func luLinkClicked(sender: UITapGestureRecognizer){
        if let url = URL(string: "https://www.lu.se/"),
                UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
        }
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
