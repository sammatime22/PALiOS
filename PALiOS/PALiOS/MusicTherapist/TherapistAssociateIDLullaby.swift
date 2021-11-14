//
//  TherapistAssociateIDLullaby.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//
//  This View Controller title is "Record Lullaby", even though the view controller title is Associate ID-Lullaby; May need fix

import UIKit
import AVFoundation
import Firebase

class TherapistAssociateIDLullaby: UIViewController, AVAudioRecorderDelegate {

    var ref: DatabaseReference!
    var patientData = [String: patientInfo]()
    var canRecord: Bool!
    @IBOutlet var recordText: UIButton!
    var fileName: String!
    var session: AVAudioSession!
    var audioRecord: AVAudioRecorder!
    @IBOutlet var stopButtonControl: UIButton!
    @IBOutlet var recordButtonControl: UIButton!
  
    @IBAction func returnMain(_ sender: Any) {
      performSegue(withIdentifier: "recordtherapistmaintherapist", sender: self)
    }
  
    //ID of the Patient
    @IBOutlet var patientID: UITextField!
  
  
    //Name of the lullaby
    @IBOutlet var lullabyName: UITextField!
  
    //Records music while pressed
    @IBAction func recordMusic(_ sender: Any) {
      recordButtonControl.isEnabled = false
      //Setup - Validate User
      if(patientData[patientID.text!] != nil){
        if(patientData[patientID.text!]?.hospitalID == patientID.text!){
          if(lullabyName.text != nil){
            if(canRecord){
              let underscoreString: String = lullabyName.text!.replacingOccurrences(of: " ", with: "_")
              print("debug")
              //print("Here's the path: " + songFilePath + " Which has a type of \(songFilePath.self)")
              //Start recording
              startRecording(audioFileName: underscoreString)
              canRecord = false
            } else { createAlert(title: "Record Issue", message: "Cannot record at this time") }
          } else { createAlert(title: "No Lullaby Name", message: "Lullaby Name field has no data") }
        } else { createAlert(title: "ID Error", message: "Patient ID does not match any existing ID") }
      } else { createAlert(title: "ID Error", message: "Patient ID does not exist") }
      
    }
  
  
    //Stops the recording and takes the user to the next screen
    @IBAction func stopRecording(_ sender: UIButton) {
        stopRecordingMusic(success: true)
        //Preform Segue After Recording
        performSegue(withIdentifier: "recordtherapistlullabytherapist", sender: self)
    }
  
  
    override func viewDidLoad() {
      super.viewDidLoad()
      recordButtonControl.isEnabled = true
      stopButtonControl.isEnabled = false
      
      self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
      //Required setup for servicing AVAudioSession
      session = AVAudioSession.sharedInstance()
      do {
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try session.setActive(true)
        session.requestRecordPermission(){ [unowned self] allowed in
          DispatchQueue.main.async {
            if allowed {
              print("Can record audio!")
            } else {
              self.createAlert(title: "AVAudioSession Error", message: "Could not access permission to use audio recording capabilities of the iOS device.")
            }
          }
        }
      } catch {
          self.createAlert(title: "AVAudioSession Error", message: "Could not access permission to use audio recording capabilities of the iOS device.")
      }
      //For "recordMusic" UIButton functionality (See above)
      canRecord = true
      
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
        // Check the patient data existing at the database
    }

    //Function to start recording
  func startRecording(audioFileName: String) {
    let audioPath: URL = createRecordURL().appendingPathComponent(audioFileName + ".m4a")
    let settings = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 16000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
      
    do{
      print("Makes it to do statement")
      audioRecord = try AVAudioRecorder(url: audioPath, settings: settings)
      print("Makes it past try statement")
      recordText.setTitle("NOW RECORDING",for: .normal)
      audioRecord.delegate = self
      audioRecord.record()
    }
    catch let error as NSError {
      stopRecordingMusic(success: false)
      print(error.debugDescription)
    }
      print("A Statement to Start")
      stopButtonControl.isEnabled = true
    }
  
    //Function to stop recording
  func stopRecordingMusic(success: Bool) {
    audioRecord.stop()
    canRecord = true
    print(audioRecord.url)
    if !success {
      createAlert(title: "Error", message: "An error occured in recording this audio")
    }
  }
  
  func createRecordURL() -> URL {
    let fileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docsDirect = fileDirectory[0]
    return docsDirect
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
  
  //Send data over segue
  override func prepare(for segue: UIStoryboardSegue, sender: (Any)?){
    if segue.destination is TherapistRecordLullaby{
      let lullabyProperties = segue.destination as? TherapistRecordLullaby
      lullabyProperties!.songURL = audioRecord.url
      lullabyProperties?.lullabyNamePass = lullabyName.text
      lullabyProperties?.patientIDPass = patientID.text
    }
  }
}
