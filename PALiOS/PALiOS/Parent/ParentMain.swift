//
//  ParentMain.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase

class ParentMain: UIViewController {

  var ref: DatabaseReference!
  var patientID = ""
  var patient = ""
  var status = ""
  
  @IBAction func status(_ sender: Any) {
    performSegue(withIdentifier: "mainparentstatusparent", sender: self)
  }
  
  @IBAction func help(_ sender: Any) {
    performSegue(withIdentifier: "mainparenthelpparent", sender: self)
  }
  
  @IBAction func logout(_ sender: Any) {
    performSegue(withIdentifier: "mainparentlogin"
    , sender: self)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    
    ref = Database.database().reference().child("Patient")
    ref.queryOrdered(byChild: "ParentAccount").observe(.value){ (snapshot) in
      for patients in snapshot.children.allObjects as! [DataSnapshot] {
        let patientObject = patients.value as? [String: AnyObject]
          if patientObject?["ParentAccount"] as? String == access {
            self.patientID = patientObject?["HospitalID"] as! String
            self.patient = patientObject?["FirstName"] as! String
            self.status = patientObject?["CurrentStatus"] as! String
          }
        }
      }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.destination is ParentStatus{
        let segueProperties = segue.destination as? ParentStatus
        segueProperties?.patientName = "Patient: " + patient
        segueProperties?.patientID = "Patient ID: " + patientID
        segueProperties?.status = status
      }
    }
}
