//
//  DoctorHelp.swift
//  PALiOS
//
//  Created by sammatime22 on 1/24/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit

class DoctorHelp: UIViewController {

  @IBOutlet var helpText: UITextView!
  
  @IBAction func returnHome(_ sender: Any) {
    performSegue(withIdentifier: "helpdoctormaindoctor", sender: self)
  }
  //Loads the help text
  override func viewDidLoad() {
    super.viewDidLoad()
    helpText.text = "View Statistics\n\tThis menu allows the physician or medical professional of a premature infant residing in the NICU to view how their patient is responding to the PAL Device. The information presented on this scren is all of the data collected from the child using the device. If no information is displayed, then the Music Therapist has yet to use the PAL Device with your patient.\n\nHelp\n\tThis menu displays information on how to properly use the PAL application along with what information will be displayed on each menu. If you have any other questions, please see the Music Therapist working with your patient.\n\nLogout\n\tWhen the logout button on the main menu is pressed, the user is redirected to the login screen."
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
