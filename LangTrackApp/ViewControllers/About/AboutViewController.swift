//
//  AboutViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
//
//  Modified by Viktor Czyżewski
//

import UIKit

class AboutViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var theScrollview: UIScrollView!
    
    var showingTopShadow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view1.layer.cornerRadius = 12
        view1.setLargeViewShadow()
        view2.layer.cornerRadius = 12
        view2.setLargeViewShadow()
        
        theScrollview.delegate = self
        setAboutText()
        setTeamText()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 5{
            if showingTopShadow == false{
                topView.setLargeViewShadow()
                showingTopShadow = true
            }
        }else{
            if showingTopShadow == true{
                topView.removeShadow()
                showingTopShadow = false
            }
        }
    }
    
    func setAboutText(){
//        let theHeader = "Project description"
        let finalString = NSMutableAttributedString(string: "\(translatedAboutText1)\n\n", attributes: attributeLtaBlueText)
        finalString.append(NSAttributedString(string: "\(translatedFundedBy)\n", attributes: attributeSmallText))
        
        //image
        /*
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "\(translatedFounderImage).png")
        let image1String = NSMutableAttributedString(attachment: image1Attachment)
        let myRange = NSRange(location: 0, length: image1String.length)
        image1String.addAttributes([NSAttributedString.Key.link: URL(string: translatedFounderAddress)!], range: myRange)
        finalString.append(image1String)
         */
        
        aboutTextView.attributedText = finalString
    }
    
    func setTeamText(){
        
        let finalString = NSMutableAttributedString(string: "\(translatedTeam)\n\n", attributes: attributeLtaBlueHeaderText)
        
        
        let thename1 = "Zoe Handley"
        finalString.append(NSAttributedString(string: thename1, attributes: attributeLtaRedHeaderText))
        let theDescription1 = ", \(translatedMarianneInfo)\n"
        finalString.append(NSAttributedString(string: theDescription1, attributes: attributeLtaBlueText))
        
        let thename2 = "Clare Wright"
        finalString.append(NSAttributedString(string: thename2, attributes: attributeLtaRedHeaderText))
        let theDescription2 = ", \(translatedJonasInfo)\n"
        finalString.append(NSAttributedString(string: theDescription2, attributes: attributeLtaBlueText))
        
        let thename3 = "Philip Harrison"
        finalString.append(NSAttributedString(string: thename3, attributes: attributeLtaRedHeaderText))
        let theDescription3 = ", \(translatedHenrietteInfo)\n"
        finalString.append(NSAttributedString(string: theDescription3, attributes: attributeLtaBlueText))
        
        let thename4 = "Stuart Lacy"
        finalString.append(NSAttributedString(string: thename4, attributes: attributeLtaRedHeaderText))
        let theDescription4 = ", \(translatedJosefInfo)\n"
        finalString.append(NSAttributedString(string: theDescription4, attributes: attributeLtaBlueText))
        
        let thename5 = "Viktor Czyzewski"
        finalString.append(NSAttributedString(string: thename5, attributes: attributeLtaRedHeaderText))
        let theDescription5 = ", \(translatedStephanInfo)\n"
        finalString.append(NSAttributedString(string: theDescription5, attributes: attributeLtaBlueText))
        
        
        teamLabel.attributedText = finalString
        
    }
    
    func setTechText(){
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
