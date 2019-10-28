//
//  MountainVC.swift
//  MountainTop
//
//  Created by Daisy on 03/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit
import Lottie
import ImageIO


class MountainVC: UIViewController {
  
  // MARK: - Property
  private let mountainName = ["도봉산", "수락산", "불암산", "용마산", "아차산", "구룡산", "대모산", "우면산", "관악산(관음사)", "북한산(효자동)", "북한산(우이동)", "북악산(한양도성)", "청계산(매봉)", "삼성산", "인왕산(사직단)"]
  
  private let mountainXaxis = [0.542, 0.729, 0.771, 0.781, 0.771, 0.646, 0.750, 0.573, 0.495, 0.365, 0.417, 0.401, 0.677, 0.406, 0.292]
  private let mountainYaxis = [0.313, 0.313, 0.380, 0.563, 0.615, 0.802, 0.823, 0.771, 0.833, 0.380, 0.333, 0.479, 0.870, 0.859, 0.479]
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.zoomScale = 1
    scrollView.minimumZoomScale = 1
    scrollView.maximumZoomScale = 1.8
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    view.addSubview(scrollView)
    return scrollView
  }()
  
  private lazy var mtnImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.loadGif(name: "mtnTop")
    imageView.contentMode = .scaleAspectFit
    scrollView.addSubview(imageView)
    return imageView
  }()
  
  var array = [UIButton]()
  
  private lazy var mapButtons: [UIButton] = {
    for i in 0..<mountainName.count {
      let btn = UIButton(type: .custom)
      btn.tag = i + 1
      btn.setTitle("\(mountainName[i])", for: .normal)
      btn.setTitleColor(.darkGray, for: .normal)
      btn.titleLabel?.font = UIFont.systemFont(ofSize: 5)
      btn.backgroundColor = .white
      btn.alpha = 0.8
      btn.layer.cornerRadius = 5 // FIXME: - 나중에 보고 수정
      btn.clipsToBounds = true
      btn.addTarget(self, action: #selector(didTapMoutainButton(_:)), for: .touchUpInside)
      self.mtnImageView.addSubview(btn)
      self.mtnImageView.isUserInteractionEnabled = true
      btn.isUserInteractionEnabled = true
      array.append(btn)
    }
    return array
  }()
  
  // MARK: - App Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.delegate = self
    startAnimation()
    configureAutoLayout()
    view.backgroundColor = UIColor(named: "MountainTab")
  }
  
  // MARK: - Action Method
  private func startAnimation() {
    
    UIView.animateKeyframes(withDuration: 0.3, delay: 1, animations: {
      
    }) { _ in
      self.dispalyFlags()
      self.zoomingImageView()

    }
  }
  
  @objc func didTapMoutainButton(_ sender: UIButton) {
    let rankingVC = RankingVC()
    rankingVC.buttonTag = sender.tag
    
    rankingVC.modalPresentationStyle = .overCurrentContext
    present(rankingVC, animated: false)
  }
  
  private func zoomingImageView() {
    UIView.animate(withDuration: 1) {
      self.scrollView.zoomScale = 1.5
      self.scrollView.minimumZoomScale = 1.5
  
      self.mtnImageView.snp.updateConstraints {
        let yValue = self.view.frame.height * 0.25
        $0.centerY.equalToSuperview().offset(-yValue)
      }
    }
  }
  
  private func dispalyFlags() {
    for i in 0..<mapButtons.count {
      mapButtons[i].snp.makeConstraints {
        $0.centerX.equalTo(self.mtnImageView.snp.trailing).multipliedBy(self.mountainXaxis[i])
        $0.centerY.equalTo(self.mtnImageView.snp.bottom).multipliedBy(self.mountainYaxis[i])
//        print(mountainXaxis[i])
      }
    }
    self.scrollView.canCancelContentTouches = true
    return
  }
  
  // MARK: - AutoLayout
  private func configureAutoLayout() {
    let deviceWidht = UIScreen.main.bounds.width
    
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
      $0.center.equalTo(view.snp.center)
    }
    
    mtnImageView.snp.makeConstraints {
      let yValue = view.frame.height * 0.25
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-50)
      $0.width.height.equalTo(deviceWidht)
    }
  }
}


extension MountainVC: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return mtnImageView
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print("⛱ did scroll ⛱")
  }
}

