//
//  DoctorSelectPatient.swift
//  PALiOS
//
//  Created by sammatime22 on 1/25/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit

class DoctorSelectPatient: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet var patientSelectNameID: UITableView!
  var patientNameAndID = [Int: String]()
  var tillAt = [String]()
  var identification = ""
  
  @IBAction func returnHome(_ sender: Any) {
    performSegue(withIdentifier: "selectdoctormaindoctor", sender: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    patientSelectNameID.dataSource = self
    patientSelectNameID.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

    //MARK: Table View Setup
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
    performSegue(withIdentifier: "selectdoctorviewdoctor", sender: self)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is DoctorViewStatistics {
      let selectProperties = segue.destination as? DoctorViewStatistics
      selectProperties?.passedID = identification
    }
  }

}
