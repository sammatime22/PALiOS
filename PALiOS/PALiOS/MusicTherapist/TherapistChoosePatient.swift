//
//  TherapistChoosePatient.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase

class TherapistChoosePatient: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var patientSelectTableView: UITableView!
  var patientNameAndID = [Int: String]()
  var patientIDs = [String]()
  var roundAndStatusArray = [roundAndStatus]()
  var rasPassedArray = [roundAndStatus]()
  var tillAt: [String] = []
  var identification = ""
  var ref: DatabaseReference!
  
  @IBAction func returnMain(_ sender: Any) {
    performSegue(withIdentifier: "choosetherapistmaintherapist", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    //Get the IDs for the Firebase Parsing
    var i = 0
    while (i < patientNameAndID.count){
      tillAt = patientNameAndID[i]!.components(separatedBy: " : ")
      patientIDs.append(tillAt[1])
      i += 1
    }
    
    //Collects all available Data for Round And Status Prior to Assembling Buttons due to Firebase Lag
    for id in patientIDs {
      ref = Database.database().reference().child("Statistics").child(id)
      ref.queryOrdered(byChild: "Round").observe(.value){ (snapshot) in
        for round in snapshot.children.allObjects as! [DataSnapshot] {
          let roundObject = round.value as! [String: AnyObject]
          if (roundObject["ReleasedToParent"] as! String) == "No" {
            let passedRoundData = roundObject["Round"] as! String
            let passedStatusData = roundObject["Result"] as? String
            let rasStruct = roundAndStatus(identification: id, round: passedRoundData, status: passedStatusData ?? "No Info")
            self.roundAndStatusArray.append(rasStruct)
          }
        }
      }
    }
    
    patientSelectTableView.delegate = self
    patientSelectTableView.dataSource = self
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return patientNameAndID.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PatientSelectTableViewCell", for: indexPath) as? PatientSelectTableViewCell else {
      fatalError("The dequeued cell is not an instance of PatientSelectTableViewCell.")
    }
    //PatientNameAndID is actually a name given to the storyboard cell preview box
    cell.PatientNameAndID.text = patientNameAndID[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    tillAt = patientNameAndID[indexPath.row]!.components(separatedBy: " : ")
    self.identification = tillAt[1]
    
    for data in roundAndStatusArray{
      if(data.identification == tillAt[1]){
        self.rasPassedArray.append(data)
      }
    }
    performSegue(withIdentifier: "therapistchoosetherapistrelease", sender: self)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is TherapistReleasePatient{
      let segueProperties = segue.destination as? TherapistReleasePatient
      segueProperties?.patientID = identification
      segueProperties?.roundAndStatusArray = rasPassedArray
    }
  }
  
  //Alert Function
  func createAlert(title: String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
    self.present(alert, animated: true, completion: nil)
  }
}
