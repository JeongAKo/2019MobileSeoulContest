//
//  NMapViewController.swift
//  MountainTop
//
//  Created by Daisy on 02/09/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit
import NMapsMap
//import CoreLocation

class NMapVC: UIViewController, NMFMapViewDelegate {
  
  // MARK: - Property
  private let naverMapView = NMFNaverMapView(frame: .zero)
  private let activityIndicator = UIActivityIndicatorView(style: .gray)
  private let recordView = RecordTopView()
  private let calender = Calendar.current
  private var timer = Timer()
  private lazy var startDate = Date()
  
  private lazy var recordContainerView: UIView = {
    let rView = UIView()
    rView.layer.shadowColor = UIColor.lightGray.cgColor
    rView.layer.shadowOffset = CGSize.zero
    rView.layer.shadowRadius = 10
    rView.layer.shadowOpacity = 0.5
    return rView
  }()
  
  private lazy var buttonContainerView: UIView = {
    let bView = UIView()
    bView.layer.shadowColor = UIColor.lightGray.cgColor
    bView.layer.shadowOffset = CGSize.zero
    bView.layer.shadowRadius = 10
    bView.layer.shadowOpacity = 0.5
    return bView
  }()
  
  private lazy var cameraButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("사진찍기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.init(name: "Helvetica Bold Oblique", size: 15)
    button.backgroundColor = .black
    button.alpha = 0.5
    button.addTarget(self, action: #selector(didTapCameraButton(_:)), for: .touchUpInside)
    return button
  }()
  
  lazy var imagePickerController: UIImagePickerController = {
    let controller = UIImagePickerController()
    controller.delegate = self
    controller.sourceType = .camera
    return controller
  }()
  
  private var mapLocation: NMFLocationOverlay!
  
  private var location: CLLocationManager!
  
  // MARK: - App Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    naverMapView.mapView.delegate = self
    
    mapLocation = naverMapView.mapView.locationOverlay

    addsubViews(naverMapView)
    configureMapView(naverMapView)
    makeConstraints()
    
    popInfoWindow()
    
    location = CLLocationManager()
    location.desiredAccuracy = kCLLocationAccuracyBest
    location.distanceFilter = 10_000.0
    location.delegate = self
    location.startUpdatingLocation()
    
    displayFlags()
  }
  
  private func displayFlags() {
    let moutainDB = MauntainDatabase()
    
    guard let db = moutainDB else {
      return print("moutainDB is nil")
    }
    
    let data = db.getMountainInfomations()
    
    print( "got the `mountain data` successfully")
    
    let encoder = JSONEncoder()
    
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
    
    guard let jsonData = try? encoder.encode(data) else { return }
    
//    if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8) {
//      print("📌jsonString📌",jsonString)
//    }
    
    guard let moutain = try? JSONDecoder().decode([MountainInfo].self, from: jsonData) else { return print("decoding fail")}
    print("⛰moutain⛰:\(moutain)")
    print("📌moutain[0]📌",moutain[0])
    print("⌛️Mtn Count⌛️",moutain.count)
    
    for i in 0...(moutain.count - 1) {
      
      let startMarker = NMFMarker(position: NMGLatLng(lat: moutain[i].infoLat, lng: moutain[i].infoLong))
      startMarker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
        self?.infoWindow.open(with: startMarker)
        return true
      }
      startMarker.userInfo = ["title" : "\(moutain[i].name)"]
      startMarker.captionText = "\(moutain[i].name) 시작점"
      startMarker.iconImage = NMFOverlayImage(name: "icon")
      startMarker.mapView = naverMapView.mapView
      
      let finishMarker = NMFMarker(position: NMGLatLng(lat: moutain[i].mtLat, lng: moutain[i].mtLong))
      finishMarker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
        self?.infoWindow.open(with: finishMarker)
        return true
      }
      finishMarker.userInfo = ["title" : "\(moutain[i].name)"]
      finishMarker.iconImage = NMFOverlayImage(name: "finish")
      finishMarker.mapView = naverMapView.mapView
    }
  }
  
  let infoWindow = NMFInfoWindow()
  var customInfoWindowDataSource = CustomInfoWindowDataSource()
  
  fileprivate func popInfoWindow() {

    infoWindow.dataSource = customInfoWindowDataSource
    infoWindow.offsetY = 5
    infoWindow.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
      self?.infoWindow.close()
      return true
    }
  }
  
  //지도 클릭시 CustomInfoWindow close
  func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
    infoWindow.close()
    
    print("CGPoint", CGPoint())
    print("NMGLatLng", NMGLatLng())
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    applyDesign()
  }
  
  
  // MARK: - Action method
  private func configureMapView(_ naverMapView: NMFNaverMapView) {
    naverMapView.mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)  // 등산로 모드
    naverMapView.positionMode = .direction
    naverMapView.showLocationButton = true   // 현 위치 버튼이 활성화되어 있는지 여부
    naverMapView.mapView.buildingHeight = 0.5
 
  }
  
  private func time() {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(keepTimer), userInfo: nil, repeats: true)
  }
  
  fileprivate func addsubViews(_ naverMapView: NMFNaverMapView) {
    view.addSubview(naverMapView)
    view.addSubview(recordContainerView)
    view.addSubview(buttonContainerView)
    recordContainerView.addSubview(recordView)
    buttonContainerView.addSubview(cameraButton)
  }
  
  private func presentAlert(title: String, message: String) {
    print("✏️ presentAlert")
    activityIndicator.stopAnimating()
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
  
  private func saveToAlbum(named: String, image: UIImage) {
    print("📍saveToAlbum")
    let album = CustomAlbum(name: named)
    album.save(image: image) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .success(_):
          self.presentAlert(title: "사진 저장", message: "사진이\(named) 앨범에 저장 되었습니다.")
        case .failure(let err):
          self.presentAlert(title: "Error", message: err.localizedDescription)
        }
      }
    }
  }
  
  private func applyDesign() {
    view.layoutIfNeeded()
    
    let recordVCorner = recordContainerView.frame.height / 5
    recordView.layer.cornerRadius = recordVCorner
    recordView.clipsToBounds = true
    
    let cameraButtonCorner = cameraButton.frame.height / 5
    cameraButton.layer.cornerRadius = cameraButtonCorner
    cameraButton.clipsToBounds = true
  }
  
  @objc private func keepTimer() {
    
    let startTime = calender.dateInterval(of: .nanosecond, for: startDate)
    var endDate = Date()
    let endTime = calender.dateInterval(of: .nanosecond, for: endDate)
    let timePeriod = calender.dateComponents([.second], from: startTime!.start, to: endTime!.end)
    let progressTime = timePeriod.second ?? 0
    
    //    let duration = TimeInterval(Double(progressTime ?? 0))
    
    let duration = TimeInterval(progressTime)
    recordView.challengerRecordTimeLabel.text = duration.asTimeString() // Duration -> Date
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let endFommat = dateFormatter.string(from: endDate)
    let startFommat = dateFormatter.string(from: startDate)
    
    print("endFommat", endFommat)
    print("startFommat", startFommat)
    print("timePeriod", timePeriod)
    print("progressTime", progressTime)
  }
  
  @objc func didTapCameraButton(_ sender: UIButton) {
    present(imagePickerController, animated: true)
  }
  
  @objc private func presentCamera(_ sender: Notification) {
    
    guard let userInfo = sender.userInfo as? [String: UIImagePickerController],
      let picker = userInfo["presentCamera"]
      else {
        return print("fail downCasting")
    }
    
    print("location lat: \(mapLocation.location.lat), location lng: \(mapLocation.location.lng)")
    print("location.location?.altitude: \(String(describing: location.location?.altitude))")
    present(picker, animated: true)
  }
  
  @objc private func presentAlert(_ sender: Notification) {
    
    guard let userInfo = sender.userInfo as? [String: UIAlertController],
      let alert = userInfo["presentAlert"]
      else {
        return print("fail downCasting")
    }
    
    present(alert, animated: true)
  }
  
  // MARK: - AutoLayout
  private func makeConstraints() {
    
    naverMapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    recordContainerView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
      $0.height.equalToSuperview().multipliedBy(0.1)
    }
    
    recordView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview()
    }
    
    buttonContainerView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.height.equalToSuperview().multipliedBy(0.05)
    }
    
    cameraButton.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview()
    }
  }
}


extension NMapVC: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("------------status-------------")
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      print("Authorized")
    default:
      print("Unauthorized")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    //    locations.first?.altitude
    //    print("altitude", locations.first?.altitude)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    print("trueHeading : ", newHeading.trueHeading)
    print("magnetincHeading :", newHeading.magneticHeading)
    print("values \(newHeading.x), \(newHeading.y), \(newHeading.z)")
  }
}

extension NMapVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else {
      print("Image not found!")
      return
    }
    
    saveToAlbum(named: "서울 봉우리", image: image)
    print("📷saved image")
    time()
    imagePickerController.dismiss(animated: true, completion: nil)
  }
}

extension NMGLatLng {
  func positionString() -> String {
    return String(format: "(%.5f, %.5f)", lat, lng)
  }
}
