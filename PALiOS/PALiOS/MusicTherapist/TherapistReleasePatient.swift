//
//  TherapistReleasePatient.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase

class TherapistReleasePatient: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet var patientAndTherapistIdentification: UILabel!
  @IBOutlet var roundAndStatTableView: UITableView!
  var ref: DatabaseReference!
  var roundAndStatusArray = [roundAndStatus]()
  var patientID = ""
  
  @IBAction func returnChoose(_ sender: Any) {
    performSegue(withIdentifier: "therapistreleasetherapisthome", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    //Make View Controller Data Source/Delegate
    roundAndStatTableView.dataSource = self
    roundAndStatTableView.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (roundAndStatusArray.count)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "PatientSelectTableViewCell", for: indexPath) as? PatientSelectTableViewCell else {
      fatalError("The dequeued cell is not an instance of PatientSelectTableViewCell.")
    }
    let text = "Round: " + roundAndStatusArray[indexPath.row].round + "\tStatus: " + roundAndStatusArray[indexPath.row].status
    cell.PatientNameAndID.text = text
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    //Edit contents of statistics - round
    var refRound = ref
    refRound = Database.database().reference().child("Statistics").child(patientID).child(roundAndStatusArray[indexPath.row].round).child("ReleasedToParent")
    refRound?.setValue("Yes")
    
    //Edit statistics of child
    ref = Database.database().reference().child("Patient").child(patientID).child("CurrentStatus")
    ref.setValue(roundAndStatusArray[indexPath.row].status)
    
    createAlert(title: "Completed Transfer", message: "The Round " + roundAndStatusArray[indexPath.row].round + " statistics have successfully been passed!")
    
    performSegue(withIdentifier: "therapistreleasetherapisthome", sender: self)
    
  }
  
  //Alert Function
  func createAlert(title: String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
    self.present(alert, animated: true, completion: nil)
  }
}
