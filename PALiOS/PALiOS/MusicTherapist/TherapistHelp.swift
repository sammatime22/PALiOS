//
//  TherapistHelp.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit

class TherapistHelp: UIViewController {


  @IBOutlet var helpfulText: UITextView!
  
  
  @IBAction func returnMain(_ sender: Any) {
    performSegue(withIdentifier: "helptherapistmaintherapist", sender: self)
  }
  
  /* Help Text */
  override func viewDidLoad() {
    super.viewDidLoad()
    helpfulText.text = "View Statistics\n\tThis menu allows the music therapist of a premature infant residing in the NICU to view how their patient is responding to the PAL Device. The information presented on this screen is all of the data collected from the child using the device. If no information is displayed, then the Music Therapist has yet to use the PAL Device with their patient.\n\nRelease Information\n\tThe menu allows the music therapist of a premature infant residing in the NICU to release how their patient is responding to the PAL Device to the child's parents or guardians. If no information is displayed, then the Music Therapist has yet to use the PAL Device with their patient or all of the data for their patient has been released.\n\nCreate Parent/Guardian Account\n\tThis menu allows the music therapist of a premature infant residing in the NICU to create a PAL Device account or the child's parents or guardians. A valid email address along with the child's Hospital I.D. is required to set up the account.\n\nAdd PAL Device\n\tThis menu allows the music therapist of a premature infant residing in the NICU to associate a particular device to a parient. Note this needs to be done prior to every time the device is to be accessed.\n\nRecord Lullaby\n\tThis menu allows the music therapist of a premature infant residing in the NICU to record a lullaby to be associated with a particular patient.\n\nHelp\n\tThis menu displays information on how to properly use the PAL application along with what information will be displayed on each menu. If you have any other questions, please see the Music Therapist working with your patient.\n\nLogout\n\tWhen the logout button on the main menu is pressed, the user is redirected to the login screen."
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    }

    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
    }
}
