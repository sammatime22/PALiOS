//
//  DoctorObserveStatistics.swift
//  PALiOS
//
//  Created by sammatime22 on 4/18/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase

class DoctorObserveStatistics: UIViewController, UITableViewDataSource, UITableViewDelegate {

  var ref: DatabaseReference!
  var roundObserved: String!
  var patientID: String!
  var timeAndPressure = [Int: String]()
  @IBOutlet var dataViewerTableView: UITableView!
  
  //To return to the Home screen
  @IBAction func returnHome(_ sender: Any) {
    performSegue(withIdentifier: "doctorstatsdoctormain", sender: self)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataViewerTableView.dataSource = self
    dataViewerTableView.delegate = self
    
    var i = 0
    
    ref = Database.database().reference().child("Statistics").child(patientID).child(roundObserved).child("Data")
    ref.observe(.value, with: {(snapshot) in
      for datetime in snapshot.children.allObjects as! [DataSnapshot] {
        let datetimeObserved = datetime.key
        let pressureObserved = datetime.childSnapshot(forPath: "pressure").value as! String
        self.timeAndPressure[i] =  datetimeObserved + " : pressure " + pressureObserved
        print(self.timeAndPressure[i]!)
        i += 1
        print(i)
      }
      self.dataViewerTableView.reloadData()
    })
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return timeAndPressure.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "StatisticTableViewCell"
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StatisticsViewerTableViewCell else {
            fatalError("The dequeued cell is not an instance of StatisticsViewerTableViewCell.")
    }
    cell.StatisticTableViewCellText.text = self.timeAndPressure[indexPath.row]
    return cell
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
