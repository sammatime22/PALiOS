//
//  TherapistCreateAccount.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class TherapistCreateAccount: UIViewController, UITextFieldDelegate {

  var ref:DatabaseReference!
  var recheckUsers = [String: userInfo]()
  var patientData = [String: patientInfo]()
  var refHandler: UInt!
  
  @IBOutlet var PatientID: UITextField!
  
  @IBOutlet var ParentEmail: UITextField!
  
  //Creates the account for the parent of the patient
  @IBAction func craeteAccount(_ sender: UIButton) {
    //Send patient ID and email to server
    let patientID = PatientID.text
    let parentEmail = ParentEmail.text
    //print(patientID)
    //print(parentEmail)
    
    //If our patients database (stored in local dictionary) is not equal to null
    print("Debug Non-existant")
    if(patientData[patientID!] != nil){
      print("Debut Account Created")
      //And if the account is not yet created
      if((patientData[patientID!]?.hospitalID == patientID) && (patientData[patientID!]?.parentAccountCreated == "No")){
        print("Debug Account Passes Tests")
        //Generate a new password
        let Capital_Char = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let LC_Char = "abcdefghijklmnopqrstuvwxyz"
        let Numbers = "1234567890"
        let Symbols = "!@#$%^&*_=+-/.?<>)"
        let randomPasswordValues: String = Capital_Char + LC_Char + Numbers + Symbols
        let len = 7
        
        var password: String = ""
        var count = 0
        while(count < len){
          let indexOfString = Int(arc4random_uniform(80))
          let indexOfRandomCharacter = randomPasswordValues.index(randomPasswordValues.startIndex, offsetBy: indexOfString)
          let retrievedCharacter = randomPasswordValues[indexOfRandomCharacter]
          password += String(retrievedCharacter)
          count += 1
        }
        print(password)
        
        //Parses to the @ symbol to create a username
        //Components parses the email at the @, and seperates it into two objects, then stored in the array "tillAt" (i.e. tillAt[0] has all the chars before '@', tillAt[1] has the rest
        let tillAt = parentEmail?.components(separatedBy: "@")
        let username = tillAt![0]
        print(username)
        
        //Pushes parent account to server ("Login") set (loginInfo)
        let toAdd = ["access":"Parent", "password":password, "username":username]
        //recheckUsers[username] = toAdd
        ref = Database.database().reference().child("Login")
        ref.child(username).setValue(toAdd)
        
        //Update patient settings
        ref = Database.database().reference().child("Patient")
        ref.child(patientID!).child("ParentAccountCreated").setValue("Yes")
        ref.child(patientID!).child("ParentAccount").setValue(username)
        
        //Display password to screen
        createAlert(title: "Account Created", message: "Parent account has been successfully created. \nUsername: \(username)\nPassword: \(password)")
        
      }
  }
    //Else, state that the following account has already been created
    createAlert(title: "Invalid Patiend ID", message: "Invalid Patient ID. Please check and try again.")
  }
  
  
  //TODO: I think here the dictionary of parent values are created
  //We also print out the data as it comes in
  @IBAction func returnMain(_ sender: Any) {
    performSegue(withIdentifier: "createtherapistmaintherapist", sender: self)
  }
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    
        //Return Key On
       PatientID.delegate = self
       ParentEmail.delegate = self
    
        //Patient Directory
        ref = Database.database().reference().child("Patient")
        ref.queryOrdered(byChild: "HospitalID").observe(.value){ (snapshot) in
          for patient in snapshot.children.allObjects as! [DataSnapshot] {
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
            self.patientData[hospitalID] = patientInfo(currentStatus: patientStatus, doctorName: patientDoctor, firstName: patientFirstName, hospitalID: hospitalID, lastName: patientLastName, lullabyRecorded: patientLullabyRecorded, palID: patientPALID, therapistName: patientTherapist, parentAccountCreated: patientParentAccountCreated, parentAccount: patientParentAccount)
          }
        }
    
        //Login Directory  TODO implimentation of struct data transfer
        ref = Database.database().reference().child("Login")
        refHandler = ref.observe(.value, with: { (snapshot) in
          let dataDict = snapshot.value as! [String: AnyObject]
          print(dataDict)
        })
        
    
        ref.queryOrdered(byChild: "username").observe(.value){ (snapshot) in
          for users in snapshot.children.allObjects as! [DataSnapshot] {
            //Collect Vlues
            let userObject = users.value as? [String: AnyObject]
            let databaseUsername = userObject?["username"] as! String
            let databasePassword = userObject?["password"] as! String
            let databaseAccess = userObject?["access"] as! String
            self.recheckUsers[databaseUsername] = userInfo(username: databaseUsername, password: databasePassword, access: databaseAccess)
          }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  //Alert Function
  func createAlert(title: String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
    self.present(alert, animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    ParentEmail.resignFirstResponder()
    return true
  }
}
