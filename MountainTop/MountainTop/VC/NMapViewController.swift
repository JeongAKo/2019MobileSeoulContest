//
//  NMapViewController.swift
//  MountainTop
//
//  Created by Daisy on 02/09/2019.
//  Copyright © 2019 Daisy. All rights reserved.
//

import UIKit
import NMapsMap

public let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.5666102, lng: 126.9783881), zoom: 14, tilt: 0, heading: 0)

class NMapViewController: UIViewController, NMFMapViewDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let naverMapView = NMFNaverMapView(frame: view.frame)
    view.addSubview(naverMapView)
    
    // FIXME: - compass 위치조정
    naverMapView.mapView.setLayerGroup(NMF_LAYER_GROUP_MOUNTAIN, isEnabled: true)  // 등산로 모드
    naverMapView.positionMode = .compass
    naverMapView.showCompass = true          // 나침반이 활성화되어 있는지 여부.
    naverMapView.showLocationButton = true   // 현 위치 버튼이 활성화되어 있는지 여부.
    
    /* FIXME: - 매표소??위치 를 마커를 추가해서 시작지점 명확히 하기 https://navermaps.github.io/ios-map-sdk/guide-ko/5-3.html
     
     
     */
    
    
    
  }
}
