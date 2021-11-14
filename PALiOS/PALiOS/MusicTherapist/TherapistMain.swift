//
//  TherapistMain.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase

class TherapistMain: UIViewController {

  var ref: DatabaseReference!
  //This dictionary is passed through to Select/Release pages
  var patientNameAndIDCollect = [Int: String]()
  
  //Logout from app
  @IBAction func logout(_ sender: Any) {
    performSegue(withIdentifier: "maintherapistlogin", sender: self)
  }
  
  //View Statistics of patients
  @IBAction func viewStatistics(_ sender: Any) {
    performSegue(withIdentifier: "maintherapistselecttherapist", sender: self)
  }

  //Release information to parents
  @IBAction func release(_ sender: Any) {
    performSegue(withIdentifier: "maintherapistchoosetherapist", sender: self)
  }
  
  //Start the PAL session
  @IBAction func palSession(_ sender: Any) {
    performSegue(withIdentifier: "maintherapistassociatetherapist", sender: self)
  }
  
  //Create a new account
  @IBAction func createAccount(_ sender: Any) {
    performSegue(withIdentifier: "maintherapistcreatetherapist", sender: self)
  }
  
  //Record a new lullaby
  @IBAction func recordTherapist(_ sender: Any) {
    performSegue(withIdentifier: "maintherapistrecordtherapist", sender: self)
  }
  
  //The help screen
  @IBAction func help(_ sender: Any) {
    performSegue(withIdentifier: "maintherapisthelptherapist", sender: self)
  }
  
  //Loading data
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    print(access)
      var i = 0
      ref = Database.database().reference().child("Patient")
      ref.queryOrdered(byChild: "HospitalID").observe(.value){ (snapshot) in
        for patient in snapshot.children.allObjects as! [DataSnapshot] {
          let patientObject = patient.value as? [String: AnyObject]
          if patientObject?["musicTherapist"] as! String == access {
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
    if segue.destination is TherapistSelectPatient{
      let selectProperties = segue.destination as? TherapistSelectPatient
      selectProperties?.patientNameAndID = patientNameAndIDCollect 
    }
    if segue.destination is TherapistChoosePatient{
      let selectProperties = segue.destination as? TherapistChoosePatient
      selectProperties?.patientNameAndID = patientNameAndIDCollect
    }
  }
}
