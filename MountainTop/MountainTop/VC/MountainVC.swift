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
    scrollView.maximumZoomScale = 3
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    view.addSubview(scrollView)
    return scrollView
  }()
  
  private lazy var myImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.loadGif(name: "mtnTop")
    imageView.contentMode = .scaleAspectFit
    scrollView.addSubview(imageView)
    return imageView
  }()
  
  //  private lazy var mapAnimationView: AnimationView = {
  //    let animationView = AnimationView()
  //    myImageView.addSubview(animationView)
  //    return animationView
  //  }()
  
  var array = [UIButton]() // FIXME: - 여기
  
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
      self.myImageView.addSubview(btn)
      self.myImageView.isUserInteractionEnabled = true
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
    view.backgroundColor = #colorLiteral(red: 0.9616169333, green: 0.9346559644, blue: 0.8509911299, alpha: 1)
  }
  
  // MARK: - Action Method
  private func startAnimation() {
    
    //    let starAnimation = Animation.named("data")
    //    mapAnimationView.animation = starAnimation
    //    mapAnimationView.center = view.center
    //    mapAnimationView.play { fisnished in
    //      print("🐠 Animaion finished 🐠")
    self.dispalyFlags()
    //      self.zoomingLottieView()
    //    }
    
    
  }
  
  @objc func didTapMoutainButton(_ sender: UIButton) {
    let rankingVC = RankingVC()
    rankingVC.buttonTag = sender.tag
    rankingVC.modalPresentationStyle = .overCurrentContext
    present(rankingVC, animated: false)
  }
  
  private func zoomingLottieView() {
    UIView.animate(withDuration: 1) {
      self.scrollView.zoomScale = 2.5
      self.scrollView.minimumZoomScale = 2.5
    }
  }
  
  private func dispalyFlags() {
    for i in 0..<mapButtons.count {
      mapButtons[i].snp.makeConstraints {
        $0.centerX.equalTo(self.myImageView.snp.trailing).multipliedBy(self.mountainXaxis[i])
        $0.centerY.equalTo(self.myImageView.snp.bottom).multipliedBy(self.mountainYaxis[i])
        print(mountainXaxis[i])
      }
    }
    self.scrollView.canCancelContentTouches = true
    print("mapButtons.count: \(mapButtons.count), \(self.scrollView.canCancelContentTouches)")
    return
  }
  
  // MARK: - AutoLayout
  private func configureAutoLayout() {
    let deviceWidht = UIScreen.main.bounds.width
    
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.center.equalTo(view.snp.center)
    }
    
    myImageView.snp.makeConstraints {
      //      $0.center.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-50)
      $0.width.height.equalTo(deviceWidht)
    }
    //    mapAnimationView.snp.makeConstraints {
    //      $0.edges.equalToSuperview()
    //    }
  }
}


extension MountainVC: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return myImageView
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print("⛱ did scroll ⛱")
  }
}

