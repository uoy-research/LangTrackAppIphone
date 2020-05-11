//
//  AboutViewController.swift
//  LangTrackApp
//
//  Created by Stephan Björck on 2020-04-30.
//  Copyright © 2020 Stephan Björck. All rights reserved.
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
    let attributeLtaBlueHeaderText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold),
                                       NSAttributedString.Key.foregroundColor: UIColor(named: "lta_blue") ?? UIColor.blue ]
    
    let attributeLtaRedHeaderText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
                                       NSAttributedString.Key.foregroundColor: UIColor(named: "lta_red") ?? UIColor.red ]
    
    let attributeLtaBlueText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                                 NSAttributedString.Key.foregroundColor: UIColor(named: "lta_blue") ?? UIColor.blue ]
    
    let attributeSmallText = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
    
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
        let theHeader = "Project description"
        let finalString = NSMutableAttributedString(string: "\(theHeader)\n\n", attributes: attributeLtaBlueHeaderText)
        
       let theText = """
By introducing an innovative smartphone technology, this project will study when, where, and how often language learners are exposed to and involved in target-language use in different learning environments outside educational contexts. This step is crucial to improve our understanding of the challenges of language learning outside of classrooms. In two case studies, we will contrast new arrivals in Sweden learning Swedish, and Swedish Erasmus students staying abroad learning a foreign language.

The research questions we ask are a) what characterises exposure to and use of the target languages in the two learning environments; b) to what extent differences in organized leisure time activities (e.g. sports, music, handicrafts, etc.) affect the quantity and quality of target-language exposure and/or use; and c) if gains in language proficiency can be related to quantity and quality of target-language exposure and/or use.

We will develop a smartphone app where learners will be regularly prompted to report their experiences with the target language and take language tests. The novelty of this method will allow for both more participants and more accurate measurements of target-language exposure and use compared to previous studies.

For second language acquisition research, the project will be important to further our understanding of the role of language exposure and use for language learning by developing a tool for a more accurate measure of these constructs. Moreover, the study of learners in two different learning environments will allow researchers, educators, and other stakeholders to gain vital insights into language learning conditions outside of the educational context.

The project is a collaboration between the Centre for Languages and Literature, and Lund University Humanities Lab. The timing is ideal since the PI researchers involved (Granfeldt & Gullberg) are currently leading a working group of experts on issues related to the proposed project (COST SAREP).
"""
        let attrText = NSAttributedString(string: "\(theText)\n\n", attributes: attributeLtaBlueText)
        finalString.append(attrText)
        
        let foundingsText = "FUNDINGS"
        let attrFounding = NSAttributedString(string: "\(foundingsText)\n", attributes: attributeSmallText)
        finalString.append(attrFounding)
        
        //image
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "stiftelsen_wallenberg.png")
        let image1String = NSMutableAttributedString(attachment: image1Attachment)
        let myRange = NSRange(location: 0, length: image1String.length)
        image1String.addAttributes([NSAttributedString.Key.link: URL(string: "https://maw.wallenberg.org/startsida")!], range: myRange)
        finalString.append(image1String)


        
        
        aboutTextView.attributedText = finalString
    }
    
    func setTeamText(){
        
        let theHeader = "Team"
        let finalString = NSMutableAttributedString(string: "\(theHeader)\n\n", attributes: attributeLtaBlueHeaderText)
        
        
        let thename1 = "Jonas Granfeldt"
        finalString.append(NSAttributedString(string: thename1, attributes: attributeLtaRedHeaderText))
        let theDescription1 = " - Language Acquisition - French Studies - Centre for Languages and Literature (PI)\n"
        finalString.append(NSAttributedString(string: theDescription1, attributes: attributeLtaBlueText))
        
        let thename2 = "Marianne Gullberg"
        finalString.append(NSAttributedString(string: thename2, attributes: attributeLtaRedHeaderText))
        let theDescription2 = " - General Linguistics - Language Acquisition - Humanities Lab - eSSENCE: The e-Science Collaboration (PI)\n"
        finalString.append(NSAttributedString(string: theDescription2, attributes: attributeLtaBlueText))
        
        let thename3 = "Henriette Arndt"
        finalString.append(NSAttributedString(string: thename3, attributes: attributeLtaRedHeaderText))
        let theDescription3 = " - Humanities Lab (Researcher)\n"
        finalString.append(NSAttributedString(string: theDescription3, attributes: attributeLtaBlueText))
        
        let thename4 = "Josef Granqvist"
        finalString.append(NSAttributedString(string: thename4, attributes: attributeLtaRedHeaderText))
        let theDescription4 = " - Humanities Lab (Research engineer - Web, Backend, Lead)\n"
        finalString.append(NSAttributedString(string: theDescription4, attributes: attributeLtaBlueText))
        
        let thename5 = "Stephan Björck"
        finalString.append(NSAttributedString(string: thename5, attributes: attributeLtaRedHeaderText))
        let theDescription5 = " - Humanities Lab (Research engineer - App iPhone Android)\n"
        finalString.append(NSAttributedString(string: theDescription5, attributes: attributeLtaBlueText))
        
        
        teamLabel.attributedText = finalString
        
    }
    
    func setTechText(){
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
