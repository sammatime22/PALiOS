//
//  DoctorViewStatistics.swift
//  PALiOS
//
//  Created by sammatime22 on 1/24/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase

class DoctorViewStatistics: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var passedID: String!
  var ref: DatabaseReference!
  var roundDateResultDict = [Int: roundDateResult!]()
  var roundSelected: String!
  
  @IBOutlet var chooseRoundViewTable: UITableView!
  
  @IBAction func returnHome(_ sender: Any) {
    performSegue(withIdentifier: "viewdoctormaindoctor", sender: self)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(passedID)
    chooseRoundViewTable.delegate = self
    chooseRoundViewTable.dataSource = self
    var i = 0
    let ref = Database.database().reference().child("Statistics").child(passedID)
    ref.queryOrdered(byChild: "Round").observe(.value){ (snapshot) in
      for round in snapshot.children.allObjects as! [DataSnapshot]{
        let roundInfo = round.value as! [String: AnyObject]
        let currentRound = roundInfo["Round"] as! String
        let currentResult = roundInfo["Result"] as? String
        let currentDate = roundInfo["Date"] as! String
        self.roundDateResultDict[i] = roundDateResult(round: currentRound, date: currentDate, result: currentResult ?? "No Info")
        i += 1
      }
      self.chooseRoundViewTable.reloadData()
    }
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return roundDateResultDict.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "PatientStatusToViewCell"
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RoundDateResultTableViewCell else {
      fatalError("The dequeued cell is not an instance of RoundDateResultTableViewCell.")
    }
    var cellText = (roundDateResultDict[indexPath.row]?!.round)! + " : " + (roundDateResultDict[indexPath.row]?!.date)!
    cellText += " : " + roundDateResultDict[indexPath.row]!!.result
    cell.RoundDateResultText.text = cellText
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    roundSelected = roundDateResultDict[indexPath.row]!!.round
    performSegue(withIdentifier: "doctorviewdoctorstatus", sender: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is DoctorObserveStatistics{
      let selectProperties = segue.destination as? DoctorObserveStatistics
      selectProperties?.patientID = passedID
      selectProperties?.roundObserved = roundSelected
    }
  }
}
