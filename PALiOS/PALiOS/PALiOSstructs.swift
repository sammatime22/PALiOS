//
//  File.swift
//  
//
//  Created by sammatime22 on 2/28/18.
//

import Foundation
import AVFoundation

//Struct for User Info
struct userInfo{
  var username: String;
  var password: String;
  var access: String;
  
  /*init(usernameValue: String, passwordValue: String, accessValue: String) {
    self.username = usernameValue
    self.password = passwordValue
    self.access = accessValue
  }*/
}

//Struct for Patient Data
struct patientInfo{
  var currentStatus: String;
  var doctorName: String;
  var firstName: String;
  var hospitalID: String;
  var lastName: String;
  var lullabyRecorded: String;
  var palID: String;
  var therapistName: String;
  var parentAccountCreated: String;
  var parentAccount: String;
  
  /*init(statusValue: String, firstNameValue: String, idValue: String, lastNameValue: String, lullabyRecordedValue: String, palIDValue: String, parentAccountCreatedValue: String, parentAccountValue: String){
    self.currentStatus = statusValue
    self.firstName = firstNameValue
    self.hospitalID = idValue
    self.lastName = lastNameValue
    self.lullabyRecorded = lullabyRecordedValue
    self.palID = palIDValue
    self.parentAccountCreated = parentAccountCreatedValue
    self.parentAccount = parentAccountValue
  }*/
}

//Struct to connect to the PAL Module
struct PALDeviceInfo {
  var uid: String;
  var inUse: String;
  var palID: String;
  var patient: String;
  
  /*init(uidValue: String, inUseValue: String, palIDValue: String, patientValue: String){
    self.uid = uidValue
    self.inUse = inUseValue
    self.palID = palIDValue
    self.patient = patientValue
  }*/
}

//Pressure data of patient
struct dataInfo {
  var pressure: String;
  var time: String;
  /*init(pressureValue: String){
    self.pressure = pressureValue
  }*/
}

//Holds Statistics data of the patient
struct statisticInfo {
  var date: String;
  var graph: String;
  var palID: String;
  var patient: String;
  var round: String;
  var status: String;
  var released: String;
  var data_info: dataInfo;
  
  /*init(dateValue: String, graphValue: String, palIDValue: String, patientValue: String, roundValue: String, statusValue: String, releasedValue: String){
    self.date = dateValue
    self.graph = graphValue
    self.palID = palIDValue
    self.patient = patientValue
    self.round = roundValue
    self.status = statusValue
    self.released = releasedValue
  }*/
}

struct statisticTimeAndData {
  var time: String;
  var data: String;
}

struct roundAndStatus {
  var identification: String;
  var round: String;
  var status: String;
}

struct Sounds {
  static var MusicHelp = AVAudioPlayer()
  static func playSound(url: URL){
    
  }
  static func stopSound(url: URL){
    
  }
}

struct roundDateResult {
  var round: String;
  var date: String;
  var result: String;
}

struct Constants {
  static let PARENT = "Parent"
  static let PHYSICIAN = "Physician"
  static let MUSIC_THERAPIST = "MusicTherapist"
  static let USERNAME = "username"
  static let PASSWORD = "password"
  static let ACCESS = "access"
}
