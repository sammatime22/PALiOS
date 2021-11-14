//
//  TherapistRecordData.swift
//  PALiOS
//
//  Created by sammatime22 on 4/7/18.
//  Copyright © 2018 sammatime22. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import AVFoundation
import CoreBluetooth
import CoreLocation

//Preface: Peripheral - Device that has the data (CBPeripheral)
//Central - Device that wants the data contained in the peripheral (CBCentralManager)
//Characteristic - properties of your device which can be read from and written to (CBCharacteristic)
//Service - collection of the characteristics (CBService)
//Advertising - Bluetooth device showing to other devices that it is searching for a connection
//Core Bluetooth - Moving parts used to extract the functionality of BLE tech

/*General workflow
 - Create instance of CBCentralManager
 - If Bluetooth services are on, scan for CBPeripherals with desired service
 - When you find a peripheral to connect to, stop scanning, connect to desired CBPeripheral
 - Inspect the CBPeripheral for available CBServices
 - When we find the Peripheral's services, we iterate through them, looking for the CBCharacteristics we are interested in
 - When we find the ones which we seek, we either read or write to the characteristics
 */


class TherapistRecordData: UIViewController, AVAudioPlayerDelegate, CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate {
  
  //Non-Bluetooth Initializer
  var dataArray = [String: dataInfo]()
  var statsArray = [String: statisticInfo]()
  var timeDataArray = [String: dataInfo]()
  var ref: DatabaseReference!
  var ref2: DatabaseReference!
  var store: StorageReference!
  var localSongURL: URL!
  var patientID: String!
  var lullabyRecorded: String!
  var lullaby: String!
  var palID: String!
  var uid: String!
  var songPath: String!
  var round = 1
  var counter = 0
  var pastValue = 0
  var audioPlay = AVAudioPlayer()
  var isPlaying = false
  @IBOutlet var buttonText: UIButton!
  var keepScanning = false
  var connected = false
  @IBOutlet var LabelTextBox: UILabel!
  var startTime: String!
  
  //Bluetooth Initializers
  var centralManager:CBCentralManager!
  var sensorTag:CBPeripheral?
  var pressureCharacteristic:CBCharacteristic?
  var pal_uuid: String!
  let sensorName = "Arduino"
  let manager = CLLocationManager()
  
  //Begin the PAL Session
  @IBAction func startPalSession(_ sender: Any) {
    if(isPlaying){
      stopMusic()
      performSegue(withIdentifier: "datatherapistratetherapist", sender: self)
    }
    
    if(!isPlaying){
      print(self.round)
      print(songPath)
      downloadMusic()
      print(localSongURL)
      isPlaying = true
      playMusic()
      if(isPlaying){
        //Bluetooth Stuff
        let opts = [CBCentralManagerOptionShowPowerAlertKey: false]
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: opts)
        buttonText.setTitle("Stop Session", for: .normal)
        self.startTime = createTimeString()
        self.sensorTag?.readValue(for: self.pressureCharacteristic!)
      }
    }
  }
  
  
  //
  //
  //
  /* initializers and such */
  override func viewDidLoad() {
    super.viewDidLoad()
    self.round = 0
    //Download the number of rounds seen by the child statistics in order to formulate what round the child is currently on
    ref = Database.database().reference().child("Statistics").child(patientID)
    ref.queryOrdered(byChild: "Round").observe(.value){ (snapshot) in
      for stats in snapshot.children.allObjects as! [DataSnapshot]{
        if let statsObject = stats.value as? [String: AnyObject]{
          if let tmp = statsObject["Round"] as? String{
            if(self.round < Int(tmp)!){
              self.round = Int(tmp)!
              print(self.round)
            }
          }
        }
      }
    }
    //Get song path
    retrieveSongPath()
    
    //Trying to add location services to check on the ble capabilities
    manager.delegate = self
    manager.requestAlwaysAuthorization()
    manager.requestWhenInUseAuthorization()
    manager.requestLocation()
    if CLLocationManager.authorizationStatus() == .notDetermined {
      print("Cannot use location services")
    }
    switch CLLocationManager.authorizationStatus() {
      case .authorizedAlways, .authorizedWhenInUse:
        print("Level 1")
      case .notDetermined:
        print("Level 2")
      case .restricted, .denied:
        print("Level 3")
      default:
        print("default")
    }
    LabelTextBox.text = "User: " + access
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lightbackground.png")!)
  }

  
  
  
  
  
  
  //
  //
  //
  /* Stuff for Music */
  //Function to start playing music
  func playMusic(){
    do {
      self.audioPlay = try AVAudioPlayer(contentsOf: self.localSongURL)
      self.audioPlay.delegate = self
      self.audioPlay.prepareToPlay()
      self.audioPlay.play()
    } catch {
      createAlert(title: "File Not Playable", message: "Remember: Ringer switch cannot be orange.")
      isPlaying = false
    }
  }
  
  //Function to stop the music playing
  func stopMusic(){
    self.audioPlay.stop()
  }
  
  //Get the song path
  func retrieveSongPath(){
    
      if(self.lullabyRecorded == "Yes"){
        self.ref = Database.database().reference().child("Lullaby").child(self.patientID)
        self.ref.observeSingleEvent(of: .value, with: {(snapshot) in
          for lullabyPull in snapshot.children {
            let snap = lullabyPull as? DataSnapshot
            self.songPath = snap?.value as! String
          }
        })
      }
      else {
        self.ref = Database.database().reference().child("Lullaby").child("default")
        self.ref.observeSingleEvent(of: .value, with: {(snapshot) in
          for lullabyPull in snapshot.children {
            let snap = lullabyPull as? DataSnapshot
            self.songPath = snap?.value as! String
          }
        })
      }
  }
  
  //Function to download music
  func downloadMusic(){
    let tillAt1 = self.songPath.components(separatedBy: patientID + "/")
    print(tillAt1)
    let tillAt2 = tillAt1[1].components(separatedBy: ".")
    print(tillAt2)
    store = Storage.storage().reference().child(patientID).child(tillAt1[1])
    print(store)
    self.localSongURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(tillAt2[0] + "." + tillAt2[1])
    print(localSongURL)
    store.getData(maxSize: 128 * 1024 * 1024, completion: {(data, error) in
      if let error = error {
        print("Error Here _______________ Level 1")
        print(error)
      } else {
        if let d = data {
          do {
            try d.write(to: self.localSongURL)
          } catch {
            print("Error Here _______________ Level 2")
            print(error)
          }
        }
      }
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    stopMusic()
    if(self.connected == true){
      self.centralManager.cancelPeripheralConnection(self.sensorTag!)
    }
  }
  
  
  
  
  //
  //
  //
  /* Stuff for Bluetooth */
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //print("CAlled")
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //print("Called")
  }
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    var showAlert = true
    var message = ""
    
    switch central.state {
    case .poweredOff:
      message = "Bluetooth on the device is not currently on"
      
    case .unsupported:
      message = "Device does not support BLE technology"
      
    case .unauthorized:
      message = "The app is not authorized to use the BLE technology"
      
    case .resetting:
      message = "The BLE Manager is interrupted due to a reset"
      
    case .unknown:
      message = "The state of the BLE Manager is unknown"
      
    case .poweredOn:
      showAlert = false
      message = "BLE capabilities are on"
      
      //print(message)
      keepScanning = true
      //_ = Timer(timeInterval: 2, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)
      
      let sensorUUID = CBUUID(string: self.uid)
      print("Scanning for Sensor with UUID: \(sensorUUID)")
      centralManager.scanForPeripherals(withServices: [sensorUUID], options: nil)
    }
    print(message)
  }
  
  @objc func pauseScan(){
    print("Pausing the scan...")
    //_ = Timer(timeInterval: 10, target: self, selector: #selector(resumeScan), userInfo: nil, repeats: false)
    centralManager.stopScan()
  }
  
  @objc func resumeScan(){
    if keepScanning {
      print("Continue scanning...")
      //_ = Timer(timeInterval: 2, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)
      centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
  }
  
  /*Seems to be the functionality to actually connect to the device*/
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    print("Did get here")
    print(peripheral.name)
    if peripheral.name == self.sensorName {
      self.keepScanning = false
      self.sensorTag = peripheral
      self.sensorTag!.delegate = self
      print("Discovered")
      //self.centralManager.stopScan()
      self.centralManager.connect(sensorTag!, options: nil)
    }
  }
  
  /*Seems to check off whenever the device has connected*/
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Has connected")
    self.connected = true
    peripheral.delegate = self
    peripheral.discoverServices(nil)
    self.centralManager.stopScan()
  }
  
  /*Upon disconnect*/
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral dict: [String : Any]) {
    self.centralManager.cancelPeripheralConnection(sensorTag!)
    connected = false
  }
  
  /*Observes characteristics of peripheral*/
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    if let services = peripheral.services {
      for service in services {
        if(service.uuid.uuidString == uid){
          peripheral.discoverCharacteristics(nil, for: service)
        }
      }
    }
  }
  
  /* Takes in data to peripheral*/
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if let characteristicPull = service.characteristics as [CBCharacteristic]! {
      for info in characteristicPull {
        if (info.uuid.uuidString == "2A58"){
          self.pressureCharacteristic = info
          peripheral.setNotifyValue(true, for: info)
        }
      }
    }
  }
  
  /* Collects the data at the pacifier */
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if error != nil {
      print("Error updating values for characteristic")
      return
    }
    if characteristic.value != nil {
      if (characteristic.uuid.uuidString == "2A58") {
        guard let data = characteristic.value else { return }
        let temp = UInt16(data:data)
        let dataString = Int(temp) / 256
        print("Recieved Data:\(String(dataString))")
        if(!self.audioPlay.isPlaying){
          if((dataString > 140) /*&& (self.pastValue > 140)*/){
            counter += 1
            if((counter % 50 == 0) /*&& (self.pastValue > 140)*/){
              playMusic()
            }
          }
          self.pastValue = dataString
        }
        timeDataArray[createTimeString()] = dataInfo(pressure:String(dataString), time: createTimeString())
      }
    }
  }
  
  /* Collects the data at the pacifier */
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    if error != nil {
      print("Error in collecting notifications")
      return
    }
    if characteristic.value != nil {
      if(characteristic.uuid.uuidString == "2A58") {
        guard let data = characteristic.value else { return }
        print("Recieved Data:\(UInt16(data:data))")
      }
      }
    }
  
  /* Creates the string for the datetime */
  func createTimeString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/mm/dd hh:mm:ssZZZ"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.timeStyle = .medium
    dateFormatter.dateStyle = .medium
    return dateFormatter.string(from: Date())
  }
  
  //Just the pop-up alert stuff
  func createAlert(title: String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
    self.present(alert, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is TherapistRateSession{
      let segueProperties = segue.destination as? TherapistRateSession
      segueProperties?.patientID = patientID
      segueProperties?.palID = palID
      segueProperties?.round = round
      segueProperties?.startingDate = startTime
      segueProperties?.timeDataArray = timeDataArray
    }
  }
}

/* To convert the data */
protocol ConvertData {
  init(data:Data)
  var data:Data{ get }
}

extension ConvertData {
  init(data:Data) {
    guard data.count == MemoryLayout<Self>.size else {
      fatalError("Data Sizes do not match")
    }
    self = data.withUnsafeBytes { $0.pointee }
  }
  var data:Data {
    var value = self
    return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
  }
}

extension UInt16:ConvertData {}
extension UInt8:ConvertData {}
extension Int:ConvertData {}


