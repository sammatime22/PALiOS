//
//  DoctorMain.swift
//  PALiOS
//
//  Created by sammatime22 on 1/24/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase

class DoctorMain: UIViewController {

  var ref: DatabaseReference!
  var patientNameAndIDCollect = [Int: String]()
  
  //To go to the Statistics Page
  @IBAction func viewStatistics(_ sender: Any) {
    performSegue(withIdentifier: "maindoctorviewdoctor", sender: self)
  }
  
  //To go to the Help Page
  @IBAction func helpGuide(_ sender: Any) {
    performSegue(withIdentifier: "maindoctorhelpdoctor", sender: self)
  }
  
  //To go to the Logout Page
  @IBAction func logout(_ sender: Any) {
    performSegue(withIdentifier: "maindoctorlogin", sender: self)
  }
  
  //Downloading child data respective to the doctor
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    
    var i = 0
    ref = Database.database().reference().child("Patient")
    ref.queryOrdered(byChild: "HospitalID").observe(.value){ (snapshot) in
      for patient in snapshot.children.allObjects as! [DataSnapshot] {
        let patientObject = patient.value as? [String: AnyObject]
        if access == patientObject?["Doctor"] as! String{
          let hospitalID = patientObject?["HospitalID"] as! String
          let patientFirstName = patientObject?["FirstName"] as! String
          let patientLastName = patientObject?["LastName"] as! String
          self.patientNameAndIDCollect[i] = patientFirstName + " " + patientLastName + " : " + hospitalID
          i += 1
        }
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is DoctorSelectPatient{
      let selectProperties = segue.destination as? DoctorSelectPatient
      selectProperties?.patientNameAndID = patientNameAndIDCollect
    }
  }
}
