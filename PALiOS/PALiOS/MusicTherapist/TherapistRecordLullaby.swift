//
//  TherapistRecordLullaby.swift
//  PALiOS
//
//  Created by sammatime22 on 1/28/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage

class TherapistRecordLullaby: UIViewController, AVAudioPlayerDelegate {

  //Objects required to listen to audio playback
  var ref: DatabaseReference!
  var store: StorageReference!
  var audioPlay: AVAudioPlayer?
  var songURL: URL!
  //Pass - Passed over from the previous view controller into this one
  var lullabyNamePass: String!
  var patientIDPass: String!
  //@IBOutlet var acceptButtonControl: UIButton!
  @IBOutlet var lullabyName: UILabel!
  @IBOutlet var patientID: UILabel!
  var nowLoading: UIActivityIndicatorView = UIActivityIndicatorView()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
    
    self.lullabyName.text = "Song: " + lullabyNamePass
    self.patientID.text = "ID: " + patientIDPass
  }

  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
  //Calls Play Music
  @IBAction func playLullaby(_ sender: Any) {
    playMusic()
  }
  
  //Sends user back to record screen, deletes contents at URL
  @IBAction func recordAgain(_ sender: Any) {
    deleteAudio()
        performSegue(withIdentifier: "lullabytherapistrecordtherapist", sender: self)
  }
  
  //Keeps recording and sends file to database
  @IBAction func acceptRecording(_ sender: Any) {
    uploadAudio()
    updatePatientData()
  }
  
  //Plays music
  func playMusic(){
    do {
      audioPlay = try AVAudioPlayer(contentsOf: songURL)
      audioPlay?.delegate = self
      audioPlay?.prepareToPlay()
      audioPlay?.play()
    } catch {
      createAlert(title: "File Not Found", message: "Please attempt to rerecord the audio.")
    }
  }
  
  //Upload Audio
  func uploadAudio(){
    store = Storage.storage().reference()
    let filepathStorage = store.child(patientIDPass).child(lullabyNamePass + ".m4a")
    filepathStorage.putFile(from: songURL)
  }
  
  //Update Patient Data
  func updatePatientData(){
    ref = Database.database().reference()
    ref.child("Patient").child(patientIDPass!).child("LullabyRecorded").setValue("Yes")
    var pathValue = "gs://seniordesigndatabase-b9b47.appspot.com/" + patientIDPass
    pathValue += "/" + lullabyNamePass + ".m4a"
    ref.child("Lullaby").child(patientIDPass!).child("path").setValue(pathValue)
  }
  
  //Delete Audio
  func deleteAudio(){
    let fileManager = FileManager.default
    do {
      try fileManager.removeItem(atPath: "\(songURL)")
    }
    catch {
      createAlert(title: "Re-Record Issue", message: "Cannot remove previously recorded file.")
    }
  }
  
  //Return to Home Screen
  @IBAction func returnToHome(_ sender: Any) {
    performSegue(withIdentifier: "recordtherapisthometherapist", sender: self)
  }
  
  
  func createAlert(title: String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
    self.present(alert, animated: true, completion: nil)
  }
}
