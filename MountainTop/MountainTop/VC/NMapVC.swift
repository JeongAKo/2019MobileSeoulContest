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
  
  private let activityIndicator = UIActivityIndicatorView(style: .gray)
  private let containerView = UIView()
  
  let recordView = RecordTopView()
  let calender = Calendar.current
  
  var timer = Timer()
  lazy var startDate = Date()
  
  private lazy var cameraButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("사진찍기", for: .normal)
    button.backgroundColor = .blue
    button.addTarget(self, action: #selector(didTapCameraButton(_:)), for: .touchUpInside)
    view.addSubview(button)
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let naverMapView = NMFNaverMapView(frame: view.frame)
    
    mapLocation = naverMapView.mapView.locationOverlay
    
    view.addSubview(naverMapView)
    view.addSubview(containerView)
    containerView.addSubview(recordView)
    configureMapView(naverMapView)
    applyDesign()
    makeConstraints()
    
    location = CLLocationManager()
    location.desiredAccuracy = kCLLocationAccuracyBest
    location.distanceFilter = 10_000.0
    location.delegate = self
    location.startUpdatingLocation()
  }
  
  private func configureMapView(_ naverMapView: NMFNaverMapView) {
    
    naverMapView.mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)  // 등산로 모드
    naverMapView.positionMode = .direction
    naverMapView.showLocationButton = true   // 현 위치 버튼이 활성화되어 있는지 여부
    //    naverMapView.mapView.locale = "en-US"    // 영문표시
    naverMapView.mapView.buildingHeight = 0.5
    
    /* FIXME: - 매표소??위치 를 마커를 추가해서 시작지점 명확히 하기 https://navermaps.github.io/ios-map-sdk/guide-ko/5-3.html
     naverMapView.mapView.showLegalNotice() // 지도 관련 법적고지
     */
  }
  
  func time() {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(keepTimer), userInfo: nil, repeats: true)
    
  }
  
  @objc func keepTimer() {
    
    let startTime = calender.dateInterval(of: .nanosecond, for: startDate)
    var endDate = Date()
    let endTime = calender.dateInterval(of: .nanosecond, for: endDate)
    let timePeriod = calender.dateComponents([.second], from: startTime!.start, to: endTime!.end)
    let progressTime = timePeriod.second
    
    recordView.challengerRecordTimeLabel.text = "\(progressTime)"
    
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
  
  func presentAlert(title: String, message: String) {
    print("✏️ presentAlert")
    activityIndicator.stopAnimating()
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
  
func saveToAlbum(named: String, image: UIImage) {
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
    let cornerRadius : CGFloat = 15.0
    
    recordView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] //하단만 cornerRadius 적용
    recordView.layer.cornerRadius = cornerRadius
    recordView.clipsToBounds = true
    
    containerView.layer.shadowColor = UIColor.darkGray.cgColor
    containerView.layer.shadowOffset = CGSize.zero
    containerView.layer.shadowRadius = 10
    containerView.layer.shadowOpacity = 0.5
    
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
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.13)
    }
    
    recordView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview()
    }
    
    cameraButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
      $0.width.equalToSuperview().multipliedBy(0.6)
      $0.height.equalToSuperview().multipliedBy(0.05)
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
