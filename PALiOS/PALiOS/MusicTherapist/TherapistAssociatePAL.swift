//
//  TherapistAssociatePAL.swift
//  PALiOS
//
//  Created by sammatime22 on 4/7/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import Firebase
import UIKit

class TherapistAssociatePAL: UIViewController {
  var lullabyRecorded: String!
  var uid: String!
  
  var ref: DatabaseReference!
  var patientInfoArray = [String: patientInfo]()
  var deviceInfoArray = [String: PALDeviceInfo]()
  @IBOutlet var patientIDText: UITextField!
  @IBOutlet var palIDText: UITextField!
  
  //Checks to see if the Patient and PAL IDs given match those in the system
  @IBAction func associateDevice(_ sender: Any) {
    let passedPatientID: String = patientIDText.text ?? ""
    let passedPALID: String = palIDText.text ?? ""
    print(passedPatientID)
    if (passedPatientID != ""){
      if (passedPALID != ""){
        if(patientInfoArray[passedPatientID]?.therapistName == access){
          //Set Patient palID info to inputted info
          ref.database.reference().child("Patient").child(passedPatientID).child("PalID").setValue(passedPALID)
          //Set Bluetooth device inuse attribute to yes
          ref.database.reference().child("Bluetooth").child(passedPALID).child("inUse").setValue("Yes")
          //Set Bluetooth device patient to current patient
          ref.database.reference().child("Bluetooth").child(passedPALID).child("Patient").setValue(passedPatientID)
          
          //Set values for segue
          self.uid = deviceInfoArray[passedPALID]?.uid
          self.lullabyRecorded = patientInfoArray[passedPatientID]?.lullabyRecorded
          performSegue(withIdentifier: "associatetherapistrecordtherapist", sender: self)
        }
      }
    }
    createAlert(title: "Invalid Fields", message: "Fields may be blank or incorrect.")
  }
  
  //Perform segue to go back to main page
  @IBAction func returnHome(_ sender: Any) {
    performSegue(withIdentifier: "associatetherapistmaintherapist", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Download Patient Data
    ref = Database.database().reference().child("Patient")
    ref.queryOrdered(byChild: "HospitalID").observe(.value){ (snapshot) in
      for patient in snapshot.children.allObjects as! [DataSnapshot]{
        let patientObject = patient.value as? [String: AnyObject]
        let patientStatus = patientObject?["CurrentStatus"] as! String
        let patientDoctor = patientObject?["Doctor"] as! String
        let patientFirstName = patientObject?["FirstName"] as! String
        let hospitalID = patientObject?["HospitalID"] as! String
        let patientLastName = patientObject?["LastName"] as! String
        let patientLullabyRecorded = patientObject?["LullabyRecorded"] as! String
        let patientPALID = patientObject?["PalID"] as! String
        let patientParentAccountCreated = patientObject?["ParentAccountCreated"] as! String
        let patientTherapist = patientObject?["musicTherapist"] as! String
        let patientParentAccount = patientObject?["ParentAccount"] as! String
        self.patientInfoArray[hospitalID] = patientInfo(currentStatus: patientStatus, doctorName: patientDoctor, firstName: patientFirstName, hospitalID: hospitalID, lastName: patientLastName, lullabyRecorded: patientLullabyRecorded, palID: patientPALID, therapistName: patientTherapist, parentAccountCreated: patientParentAccountCreated, parentAccount: patientParentAccount)
      }
    }
    
    //Download Bluetooth Data
    ref = Database.database().reference().child("Bluetooth")
    ref.queryOrdered(byChild: "palID").observe(.value){ (snapshot) in
      for device in snapshot.children.allObjects as! [DataSnapshot]{
        let deviceObject = device.value as? [String: AnyObject]
        let devicePatient = deviceObject?["Patient"] as! String
        let deviceUID = deviceObject?["UID"] as! String
        let deviceInUse = deviceObject?["inUse"] as! String
        let devicePalID = deviceObject?["palID"] as! String
        self.deviceInfoArray[devicePalID] = PALDeviceInfo(uid: deviceUID, inUse: deviceInUse, palID: devicePalID, patient: devicePatient)
      }
    }
    
    //Background Color
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  //Alert Function
  func createAlert(title: String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
    self.present(alert, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is TherapistRecordData{
      let segueProperties = segue.destination as? TherapistRecordData
      segueProperties?.patientID = patientIDText.text
      segueProperties?.palID = palIDText.text
      segueProperties?.uid = uid
      segueProperties?.lullabyRecorded = lullabyRecorded
    }
  }
}
