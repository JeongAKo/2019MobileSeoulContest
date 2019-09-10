//
//  NMapViewController.swift
//  MountainTop
//
//  Created by Daisy on 02/09/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit
import NMapsMap

class NMapVC: UIViewController, NMFMapViewDelegate {
  
  private let notiCenter = NotificationCenter.default
  
  private let containerView = UIView()
  private let recordView = RecordView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let naverMapView = NMFNaverMapView(frame: view.frame)
    
    view.addSubview(naverMapView)
    view.addSubview(containerView)
    containerView.addSubview(recordView)
    configure(naverMapView)
    applyDesign()
    addObservers()
    makeConstraints()
  }
  
  deinit {
    removeObservers()
  }

  
  private func configure(_ naverMapView: NMFNaverMapView) {
    
    naverMapView.mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)  // 등산로 모드
    naverMapView.positionMode = .direction
    naverMapView.showLocationButton = true   // 현 위치 버튼이 활성화되어 있는지 여부
    //    naverMapView.mapView.locale = "en-US"    // 영문표시
    naverMapView.mapView.buildingHeight = 0.5
    
    /* FIXME: - 매표소??위치 를 마커를 추가해서 시작지점 명확히 하기 https://navermaps.github.io/ios-map-sdk/guide-ko/5-3.html
     naverMapView.mapView.showLegalNotice() // 지도 관련 법적고지
     */
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
  
  private func addObservers() {
    notiCenter.addObserver(self,
                           selector: #selector(presentCamera(_:)),
                           name: .presentCamera,
                           object: nil      
    )
    notiCenter.addObserver(self,
                           selector: #selector(presentAlert(_:)),
                           name: .presentAlert,
                           object: nil
      
    )
  }
  
  private func removeObservers() {
    notiCenter.removeObserver(self, name: .presentCamera, object: nil)
    notiCenter.removeObserver(self, name: .presentAlert, object: nil)
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
    containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(0.2)
    }
    
    recordView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview()
      
    }
  }
}


