//
//  ParentHelp.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit

class ParentHelp: UIViewController {

  @IBOutlet var helpText: UITextView!
  
  @IBAction func returnMain(_ sender: Any) {
    performSegue(withIdentifier: "helpparentmainparent", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    helpText.text = "View Status\n\tThis menu allows the parent or guardian of a premature infant residing inthe NICU to view how their child is responding to the PAL Device. All of the information presented on this screen is released to the parent by the Music Therapist who is working closely with the child. If no information is displayed, then the Music Therapist has yet to release any information or the PAL Device has yet to be used.\n\nHelp\n\tThis menu displays information on how to properly use the PAL application along with what information will be displayed on each menu. If you have any other questions, please see the Music Therapist working with your patient.\n\nLogout\n\tWhen the logout button on the main menu is pressed, the user is redirected to the login screen."
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
