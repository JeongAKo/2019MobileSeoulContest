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
  private var recordBool = true
  private lazy var startDate = Date()
  internal var buttonTag = 0
  internal var directTab: Bool = false
  
//  private var mountainDB: MountainDatabase!
  
  private var mountainList: [MountainInfo]?
  //MountainDatabase()?.getMountainInfomations() ?? [] //{
//    if let list = MountainDatabase()?.getMountainInfomations() {
//      let mt = list
///     UserInfo.def.
//      return mt
//    } else {
//      return []
//    }
//  }()
  
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
    button.setTitle("시작위치로 이동해주세요", for: .disabled)
    button.setTitleColor(.white, for: .disabled)
    button.setTitleColor(.white, for: .normal)
    button.setTitleColor(.white, for: .selected)
    button.setTitleColor(.white, for: .highlighted)
    button.titleLabel?.font = UIFont.init(name: "Helvetica Bold Oblique", size: 15)
    button.backgroundColor = .black
    button.alpha = 0.9
    button.addTarget(self, action: #selector(didTapCameraButton(_:)), for: .touchUpInside)
    button.tag = 0
    return button
  }()
  
  private lazy var currentLocationBtn: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "currentLocation"), for: .normal)
    button.alpha = 0.7
    button.addTarget(self, action: #selector(didTapCurrentLocationBtn(_:)), for: .touchUpInside)
    return button
  }()
  
  private lazy var recordButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "recordClock"), for: .normal)
    button.alpha = 0.7
    button.addTarget(self, action: #selector(didTapRecordButton(_:)), for: .touchUpInside)
    return button
  }()
  
  lazy var imagePickerController: UIImagePickerController = {
    let controller = UIImagePickerController()
    controller.delegate = self
    controller.sourceType = .camera
    return controller
  }()
  
  private var locatoinCheckTimeInterval: Double = 10
  
  private var startMarkers: [NMFMarker] = []
  private var finishMarkers: [NMFMarker] = []
  
  private var mapLocation: NMFLocationOverlay!
  
  private lazy var location: CLLocationManager = {
    let cl = CLLocationManager()
    cl.delegate = self
    return cl
  }()
  
  // MARK: - App Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    naverMapView.mapView.delegate = self
    
    mapLocation = naverMapView.mapView.locationOverlay

    addsubViews(naverMapView)
    configureMapView(naverMapView)
    makeConstraints()
    
    popInfoWindow()
    
    settingMountainInfo()
    
    settingLocation(0)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    applyDesign()
    cameraUpdate()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
  }
  
  private func settingMountainInfo() {
    
    mountainList =  UserInfo.def.mountainList
    displayFlags()
//    mountainDB = MountainDatabase()
//
//    NotificationCenter.default.addObserver(self,
//                                           selector: #selector(fetchMountainList(_:)),
//                                           name: .fetchMountainList,
//                                           object: nil)
  }
  
  @objc private func fetchMountainList(_ sender: Notification) {
    
//    mountainList =  mountainDB?.getMountainInfomations()
//    displayFlags()
  }
  
  private func settingLocation(_ status: Int) {
    switch status {
    case 0: // normal
      self.location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      self.location.distanceFilter = 15.0
    case 1: // high
      self.location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
      self.location.distanceFilter = 1.0
    case 2: // low
      self.location.desiredAccuracy = kCLLocationAccuracyHundredMeters
      self.location.distanceFilter = 100.0
    default:
      break
    }
    location.startUpdatingLocation()
  }
  
  private func displayFlags() {
    
    
//    guard let db = moutainDB else {
//      return print("moutainDB is nil")
//    }
//
//    let moutain = db.getMountainInfomations()
//
//    print( "got the `mountain data` successfully")
//
//    let encoder = JSONEncoder()
//
//    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
//
//    guard let jsonData = try? encoder.encode(data) else { return }
//
//
//    guard let moutain = try? JSONDecoder().decode([MountainInfo].self, from: jsonData) else { return print("decoding fail")}
    guard let moutain = mountainList else { return }
    
//    print("⛰moutain⛰:\(moutain)")
//    print("📌moutain[0]📌",moutain[0])
//    print("⌛️Mtn Count⌛️",moutain.count)
    
    for i in 0...(moutain.count - 1) {
      
      let startMarker = NMFMarker(position: NMGLatLng(lat: moutain[i].infoLat, lng: moutain[i].infoLong))
      startMarker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
        self?.infoWindow.open(with: startMarker)
        print("startMarker.tag: \(startMarker.tag)")
        return true
      }
      
      startMarker.userInfo = ["title" : "\(moutain[i].name)"]
      startMarker.captionText = "\(moutain[i].name) 시작점"
      startMarker.iconImage = NMFOverlayImage(name: "icon")
      startMarker.mapView = naverMapView.mapView
      startMarker.alpha = 0.8
      startMarker.tag = UInt(i + 1)
      
      startMarkers.append(startMarker)
      
      let finishMarker = NMFMarker(position: NMGLatLng(lat: moutain[i].mtLat, lng: moutain[i].mtLong))
      finishMarker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
        self?.infoWindow.open(with: finishMarker)
        print("finishMarker.tag: \(finishMarker.tag)")
        return true
      }
      finishMarker.userInfo = ["title" : "\(moutain[i].name)"]
      finishMarker.iconImage = NMFOverlayImage(name: "finish")
      finishMarker.mapView = naverMapView.mapView
      finishMarker.alpha = 0.8
      finishMarker.tag = UInt(i + 1)
      
      finishMarkers.append(finishMarker)
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
    
    
  }
  
  
  // MARK: - Action method
  private func configureMapView(_ naverMapView: NMFNaverMapView) {
    naverMapView.mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)  // 등산로 모드
    naverMapView.positionMode = .normal
    naverMapView.mapView.buildingHeight = 0.5
    naverMapView.mapView.zoomLevel = 16
  }
  
  private func time() {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(keepTimer), userInfo: nil, repeats: true)
  }
  
  fileprivate func addsubViews(_ naverMapView: NMFNaverMapView) {
    view.addSubview(naverMapView)
    view.addSubview(recordContainerView)
    view.addSubview(buttonContainerView)
    view.addSubview(currentLocationBtn)
    view.addSubview(recordButton)
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
          
          // MARK: - gps & 고도 가져옴
          print("location lat: \(self.mapLocation.location.lat), location lng: \(self.mapLocation.location.lng)")
          print("location.location?.altitude: \(String(describing: self.location.location?.altitude))")
        case .failure(let err):
          self.presentAlert(title: "Error", message: err.localizedDescription)
        }
      }
    }
  }
  
  
  internal func cameraUpdate() {
    
    // FIXME: - 수정
    
    if directTab == true {
      print("🎸buttonTag", buttonTag)
      print("🎸mountain Lat", mountainList?[1].mtLat)
      print("🎸mountain mtLong", mountainList?[1].mtLong)
      
      guard let lat = mountainList?[buttonTag].mtLat else { return print("can't get mtn lat info") }
      guard let long = mountainList?[buttonTag].mtLong else { return print("can't get mtn lng info") }
      let mtnPosition = NMGLatLng(lat: lat, lng: long)
      let destiMountain = NMFCameraUpdate(scrollTo: mtnPosition)
      destiMountain.animation = .fly
      destiMountain.animationDuration = 1
      naverMapView.mapView.moveCamera(destiMountain)
      naverMapView.mapView.animationDuration = 0.5
      
      directTab.toggle()
      
    } else {
      let directLat = mapLocation.location.lat
      let directLong = mapLocation.location.lng
      let currentPosition = NMFCameraUpdate(scrollTo: NMGLatLng(lat: directLat, lng: directLong))
      currentPosition.animation = .fly
      currentPosition.animationDuration = 1
      naverMapView.mapView.moveCamera(currentPosition)
      naverMapView.mapView.animationDuration = 0.5
      
    }
  }
  
  private func applyDesign() {
    view.layoutIfNeeded()

    recordView.layer.cornerRadius = recordContainerView.frame.height / 5
    recordView.clipsToBounds = true
  
    cameraButton.layer.cornerRadius = cameraButton.frame.height / 5
    cameraButton.clipsToBounds = true
    
    recordButton.layer.cornerRadius = recordButton.frame.width / 2
    recordButton.clipsToBounds = true
    
    currentLocationBtn.layer.cornerRadius = currentLocationBtn.frame.width / 2
    currentLocationBtn.clipsToBounds = true
    
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
  
  public func setCameraButtonStatus(_ status: CameraButtonStatus) {
    switch status {
    case .normal:
      cameraButton.setTitle("시작위치로 이동해주세요", for: .normal)
      cameraButton.tag = CameraButtonStatus.normal.rawValue
      
    case .challenging:
      cameraButton.setTitle("도전취소", for: .normal)
      cameraButton.tag = CameraButtonStatus.challenging.rawValue
      
    case .nearStartPoint:
      cameraButton.setTitle("기록도전", for: .normal)
      cameraButton.tag = CameraButtonStatus.nearStartPoint.rawValue
      
    case .nearFinishPoint:
      cameraButton.setTitle("등반완료", for: .normal)
      cameraButton.tag = CameraButtonStatus.nearFinishPoint.rawValue
    }
    
  }
  
  // FIXME: - 상황별 record check
  @objc func didTapCameraButton(_ sender: UIButton) {
    switch sender.tag {
    case CameraButtonStatus.normal.rawValue:
      UIAlertController.showMessage("도전을 하시려면 시작위치로 이동해주세요!", vc: self)
      
    case CameraButtonStatus.challenging.rawValue:
      let no = UIAlertAction(title: "도전!!", style: .default, handler: nil)
      let yes = UIAlertAction(title: "취소...", style: .destructive) { (action) in
        if let id = UserInfo.def.recordingID {
          _ = UserInfo.def.cancelRecord(id: id)
        }
      }
      UIAlertController.showAlert(title: "도전취소", message: "등반 도전을 취소 하시나요?", actions: [no, yes], vc: self)
      
    case CameraButtonStatus.nearStartPoint.rawValue:
      let no = UIAlertAction(title: "아니요", style: .default, handler: nil)
      let yes = UIAlertAction(title: "도전!!", style: .destructive) { [weak self] (action) in
        if let _ = UserInfo.def.startChallengeMountain() {
          UIAlertController.showMessage("도전을 시작합니다.", vc: self)
        } else {
          UIAlertController.showMessage("startChallengeMountain: error", vc: self)
        }
      }
      UIAlertController.showAlert(title: "도전", message: "등반 도전을 시작 하시나요? 정해진 위치에서 기념 촬영을 해주세요", actions: [no, yes], vc: self)
      
    case CameraButtonStatus.nearFinishPoint.rawValue:
      let no = UIAlertAction(title: "아니요", style: .destructive, handler: nil)
      let yes = UIAlertAction(title: "기록", style: .default) { (action) in
        
      }
      
      UIAlertController.showAlert(title: "등반완료", message: "등반을 완료 하셨습니다! 정해진 위치에서 기념찰영을 해주세요", actions: [no, yes], vc: self)
    default:
      print("didTapCameraButton")
      break
    }
  }
  
  @objc func didTapCurrentLocationBtn(_ sender: UIButton) {
    
    let lat = self.mapLocation.location.lat
    let long = self.mapLocation.location.lng
    let currentLocation = NMGLatLng(lat: lat, lng: long)
    
    naverMapView.mapView.moveCamera(NMFCameraUpdate(scrollTo: currentLocation))
  }
  
  @objc func didTapRecordButton(_ sender: UIButton) {
    recordBool.toggle()
    
    if recordBool == true {
      recordView.isHidden = true
      recordContainerView.isHidden = true
    } else {
      recordView.isHidden = false
      recordContainerView.isHidden = false
    }
  }
  
  
  @objc private func presentCamera(_ sender: Notification) {
    
    guard let userInfo = sender.userInfo as? [String: UIImagePickerController],
      let picker = userInfo["presentCamera"]
      else {
        return print("fail downCasting")
    }
    
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
      $0.centerX.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview()
    }
    
    currentLocationBtn.snp.makeConstraints {
      $0.centerX.equalTo(cameraButton.snp.leading).offset(-38)
      $0.centerY.equalTo(cameraButton.snp.centerY)
    }
    
    recordButton.snp.makeConstraints {
      $0.centerX.equalToSuperview().multipliedBy(1.8)
      $0.centerY.equalTo(cameraButton.snp.centerY)
    }
  }
}


// MARK: - CLLocationManagerDelegate
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
    guard let current = locations.last,
      abs(current.timestamp.timeIntervalSinceNow) < self.locatoinCheckTimeInterval
    else { return print("locations is nil")}
    
    let coordinate = current.coordinate
    
    if UserInfo.def.getChallengeRecord() {  // 도전중 finish point check
      
      if UserInfo.def.nearFinishLocationCheck(userLocation: CLLocation(latitude: coordinate.latitude,
                                                                       longitude: coordinate.longitude)) {
        self.locatoinCheckTimeInterval = 3
        self.setCameraButtonStatus(.nearFinishPoint)
      } else {
        self.locatoinCheckTimeInterval = 10
        self.setCameraButtonStatus(.challenging) // 50m 이내 없음
      }
      
    } else {  // 도전중이 아닌 상태 사용자 위치처리
      if UserInfo.def.nearStartLocationCheck(userLocation: CLLocation(latitude: coordinate.latitude,
                                                                      longitude: coordinate.longitude)) {
        self.locatoinCheckTimeInterval = 3
        self.setCameraButtonStatus(.nearStartPoint) // 시작위치
      } else {
        self.locatoinCheckTimeInterval = 10
        self.setCameraButtonStatus(.normal) // 50m 이내 없음
      }
    }
//    settingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    print("trueHeading : ", newHeading.trueHeading)
    print("magnetincHeading :", newHeading.magneticHeading)
    print("values \(newHeading.x), \(newHeading.y), \(newHeading.z)")
  }
}

// MARK: -  UIImagePickerControllerDelegate
extension NMapVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else {
      print("Image not found!")
      return
    }
    
    if UserInfo.def.getChallengeRecord() {
      saveToAlbum(named: "서울 봉우리", image: image)
      print("📷saved image")
      time()
    } else {
      
    }
    
    imagePickerController.dismiss(animated: true, completion: nil)
  }
}

extension NMGLatLng {
  func positionString() -> String {
    return String(format: "(%.5f, %.5f)", lat, lng)
  }
}
