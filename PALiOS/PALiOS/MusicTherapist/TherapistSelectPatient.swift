//
//  TherapistSelectPatient.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//


import UIKit
import Firebase
class TherapistSelectPatient: UIViewController, UITableViewDataSource, UITableViewDelegate{

  @IBOutlet var selectPatientTableView: UITableView!
  var tillAt: [String] = [] 
  var identification = ""
  var patientNameAndID = [Int: String]()
  
  @IBAction func returnHome(_ sender: Any) {
    performSegue(withIdentifier: "selecttherapistmaintherapist", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    selectPatientTableView.delegate = self
    selectPatientTableView.dataSource = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  //MARK: Table View Setup
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return patientNameAndID.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "PatientSelectTableViewCell"
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PatientSelectTableViewCell else {
      fatalError("The dequeued cell is not an instance of PatientSelectTableViewCell.")
    }
    cell.PatientNameAndID.text = patientNameAndID[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    tillAt = patientNameAndID[indexPath.row]!.components(separatedBy: " : ")
    identification = tillAt[1]
    performSegue(withIdentifier: "therapistselecttherapistview", sender: self)
  }
  
  //MARK: To ViewStatistics
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is TherapistViewStatistics {
      let selectProperties = segue.destination as? TherapistViewStatistics
      selectProperties?.idPassed = identification
    }
  }
}
