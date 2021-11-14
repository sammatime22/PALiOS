//
//  ViewController.swift
//  PALiOS
//
//  Created by sammatime22 on 1/24/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

/* TODO: figure out how to move the access to a "Backend Storage" within the app */
var access = ""

class ViewController: UIViewController, UITextFieldDelegate {
  
  var loginInfo = [String : userInfo]()
  
  //Firebase variables
  var ref: DatabaseReference!
  var refHandler: UInt!
  
  //Textfields
  @IBOutlet var userField: UITextField!
  @IBOutlet var passField: UITextField!
  
  //Login Button
  @IBAction func login(_ sender: Any) {
    let tempUserInfoHolder = self.loginInfo[(userField?.text)!]
    if(tempUserInfoHolder != nil){
      if(tempUserInfoHolder?.username == userField.text && tempUserInfoHolder?.password == passField.text){
        switch(tempUserInfoHolder?.access){
          //The use of optionals in this instance could be dangerous TODO, temporary solution for now
        case Constants.PARENT?: //"Parent"?:
          access = userField.text!
          performSegue(withIdentifier: "loginmainparent", sender: self)
          break
        case Constants.PHYSICIAN?: //"Physician"?:
          access = userField.text!
          performSegue(withIdentifier: "loginmaindoctor", sender: self)
          break
        case Constants.MUSIC_THERAPIST?: //"MusicTherapist"?:
          access = userField.text!
          performSegue(withIdentifier: "loginmaintherapist", sender: self)
          break
        default:
          break
        }
      }
    }
    
    //Else, create an alert instance
    createAlert(title: "Invalid Credentials", message: "Credentials do not appear in the systems.")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    passField.delegate = self
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    //print("Hello World")
    
    ref = Database.database().reference().child("Login")
    
    //Test to print out data
    refHandler = ref.observe(.value, with: { (snapshot) in
      let dataDict = snapshot.value as! [String: AnyObject]
      print(dataDict)
    })
    
    
    //Collect data, place into our dictionary
    ref.queryOrdered(byChild: Constants.USERNAME).observe(.value) { (snapshot) in
      for users in snapshot.children.allObjects as! [DataSnapshot] {
        //getting values
        let userObject = users.value as? [String: AnyObject]
        let databaseUsername  = userObject?[Constants.USERNAME] as! String
        print(databaseUsername)
        let databasePassword  = userObject?[Constants.PASSWORD] as! String
        print(databasePassword)
        let databaseAccess = userObject?[Constants.ACCESS] as! String
        print(databaseAccess)
        self.loginInfo[databaseUsername] = userInfo(username: databaseUsername, password: databasePassword, access: databaseAccess)
    }
  }

}
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //Event Listener to Collect New Database Instances
  
  //Alert Function
  func createAlert(title: String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
    self.present(alert, animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    passField.resignFirstResponder()
    return true
  }
}
