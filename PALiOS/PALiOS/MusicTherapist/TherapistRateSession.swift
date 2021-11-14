//
//  TherapistRateSession.swift
//  PALiOS
//
//  Created by sammatime22 on 4/18/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase


class TherapistRateSession: UIViewController {

  var ref: DatabaseReference!
  var startingDate: String!
  var patientID: String!
  var palID: String!
  var result: String!
  var round: Int!
  var timeDataArray = [String: dataInfo]()
  @IBOutlet var segmentControl: UISegmentedControl!
  
  @IBAction func rateSession(_ sender: Any) {
    switch segmentControl.selectedSegmentIndex {
    case 0:
      self.result = "Above Average"
    case 1:
      self.result = "Average"
    case 2:
      self.result = "Below Average"
    default:
      self.result = "N/A"
    }
  }
  
  @IBAction func uploadSessionProgress(_ sender: Any) {
    round = round + 1
    ref = Database.database().reference().child("Statistics").child(patientID).child(String(round))
    ref.child("Date").setValue(startingDate)
    ref.child("Graph").setValue("null")
    ref.child("PalID").setValue(palID)
    ref.child("PatientID").setValue(patientID)
    ref.child("ReleasedToParent").setValue("No")
    ref.child("Result").setValue(result)
    ref.child("Round").setValue(String(round))
    for timeCell in self.timeDataArray{
      ref.child("Data").child(timeCell.key).child("pressure").setValue(timeCell.value.pressure)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //TODO: Determine a better way to cause the application to be interrupted if the user could not connect
    //to a bluetooth peripheral
    if(timeDataArray.count == 0){
      performSegue(withIdentifier: "therapistsubmittherapistmain", sender: self)
    }
    print("/************************/")
    for timeCell in timeDataArray{
      print(timeCell.key)
      print(timeCell.value.pressure)
    }
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
