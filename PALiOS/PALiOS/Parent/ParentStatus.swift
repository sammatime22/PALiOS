//
//  ParentStatus.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit

class ParentStatus: UIViewController {

  var patientName = ""
  var patientID = ""
  var status = ""
  var statusText = ""
  @IBOutlet var patientStatusText: UITextView!
  
  @IBAction func returnMain(_ sender: Any) {
    performSegue(withIdentifier: "statusparentmainparent", sender: self)
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    
        if status == "" { statusText = "No text has been released. Please see your child's music therapist for more information." }
        else if status == "Below Average" { statusText = "Your child's sucking ability is within the below average range." }
        else if status == "Average" { statusText = "Your child's sucking ability is within the average range." }
        else if status == "Above Average" { statusText = "Your child's sucking ability is proficient enough to go home." }
        patientStatusText.text = patientName + "\n" + patientID + "\n" + statusText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
