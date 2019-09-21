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
    imageView.contentMode = .scaleAspectFill
    self.scrollView.addSubview(imageView)
    return imageView
  }()
  
   private lazy var animationView: AnimationView = {
    let animationView = AnimationView()
    self.imageView.addSubview(animationView)
    return animationView
  }()

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      startAnimation()
      configureAutoLayout()
//        zoomingLottieView()
      
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    fitToScrollView()
  }
  
  
  private func startAnimation() {
    let starAnimation = Animation.named("8720-hi-wink")
    animationView.animation = starAnimation
    animationView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
    animationView.center = view.center
    animationView.play { fisnished in
      print("🐠 Animaion finished 🐠")
      self.zoomingLottieView()
    }
    
  }
  
  
  private func fitToScrollView() {
    let zoomScale = (scrollView.frame.size.width) / (imageView.image!.size.width)
    
    print("(scrollView.frame.size.width)", (scrollView.frame.size.width))
    print("(imageView.image!.size.width)", (imageView.image!.size.width))
    print("scrollView.frame.size.width / (imageView.image!.size.width)", scrollView.frame.size.width / (imageView.image!.size.width))

    scrollView.setZoomScale(zoomScale, animated: false)
  }
  
  private func zoomingLottieView() {
    
      UIView.animate(withDuration: 1) {
        self.scrollView.zoomScale = 2
        self.scrollView.minimumZoomScale = 2
    }
  }
  
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
//      $0.center.equalToSuperview()
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

