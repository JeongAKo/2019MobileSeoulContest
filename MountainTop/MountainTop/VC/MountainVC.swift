//
//  MountainVC.swift
//  MountainTop
//
//  Created by Daisy on 03/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit
import Lottie

class MountainVC: UIViewController {
  
  private let mountainName = ["도봉산", "수락산", "불암산", "용마산", "아차산", "구룡산", "대모산", "우면산", "관악산(관음사)", "북한산(효자동)", "북한산(우이동)", "북악산(한양도성)", "청계산(매봉)", "삼성산", "인왕산(사직단)"]
  
  private let mountainXaxis = [0.530, 0.685, 0.716, 0.741, 0.762, 0.600, 0.685, 0.543, 0.473, 0.388, 0.434, 0.416, 0.656, 0.438, 0.374]
  private let mountainYaxis = [0.188, 0.162, 0.268, 0.473, 0.494, 0.748, 0.730, 0.699, 0.748, 0.240, 0.226, 0.374, 0.819, 0.755, 0.399]
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.zoomScale = 1
    scrollView.minimumZoomScale = 1
    scrollView.maximumZoomScale = 3
    scrollView.delegate = self
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    view.addSubview(scrollView)
    return scrollView
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "customMap")
    imageView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
    imageView.contentMode = .scaleAspectFit
    self.scrollView.addSubview(imageView)
    return imageView
  }()
  
   private lazy var animationView: AnimationView = {
    let animationView = AnimationView()
    self.imageView.addSubview(animationView)
    return animationView
  }()
  
  // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      startAnimation()
      dispalyFlags()
      configureAutoLayout()
  }
  
  
  // MARK: - Action Method
  private func startAnimation() {
    let starAnimation = Animation.named("8720-hi-wink")
    animationView.animation = starAnimation
//    animationView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
    animationView.center = view.center
    animationView.play { fisnished in
      print("🐠 Animaion finished 🐠")
      self.zoomingLottieView()
    }
  }
  
  @objc func didTapMoutainButton(_ sender: UIButton) {
     print("🌼 button tapped 🌼")
    
  }
  
  private func zoomingLottieView() {
      UIView.animate(withDuration: 1) {
        self.scrollView.zoomScale = 2.5
        self.scrollView.minimumZoomScale = 2.5
    }
  }
  
  private func dispalyFlags() {
    
    for i in 0...(mountainName.count - 1) {
      
      let moutainButton = UIButton(type: .custom)
//      moutainButton.isUserInteractionEnabled = true 이것도 안먹네 흐음
        moutainButton.setTitle("\(mountainName[i])", for: .normal)
        moutainButton.setImage(UIImage(named: "mtnPin"), for: .normal)
        moutainButton.backgroundColor = .black
        moutainButton.alpha = 0.8
        moutainButton.addTarget(self, action: #selector(didTapMoutainButton(_:)), for: .touchUpInside)
        imageView.addSubview(moutainButton)  //view에 올리면 되는데 imageview나 scrollview에 올리면 버튼 터치가 안됨
      
      moutainButton.snp.makeConstraints {
        $0.centerX.equalTo(imageView.snp.trailing).multipliedBy(mountainXaxis[i])
        $0.centerY.equalTo(imageView.snp.bottom).multipliedBy(mountainYaxis[i])
      }
    }
  }
  
  // MARK: - AutoLayout
  private func configureAutoLayout() {
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.center.equalTo(view.snp.center)
    }
    
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.center.equalToSuperview()
    }
    
    animationView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}


extension MountainVC: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print("⛱ did scroll ⛱")
   
  }
}

