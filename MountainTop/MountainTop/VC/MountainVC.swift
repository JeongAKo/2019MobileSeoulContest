//
//  MountainVC.swift
//  MountainTop
//
//  Created by Daisy on 03/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class MountainVC: UIViewController {

//  let animationView = AnimationView()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.zoomScale = 1
    scrollView.minimumZoomScale = 0.3
    scrollView.maximumZoomScale = 2
    scrollView.delegate = self
    view.addSubview(scrollView)
    return scrollView
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "customMap")
    imageView.contentMode = .scaleAspectFit
    self.scrollView.addSubview(imageView)
    return imageView
  }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = #colorLiteral(red: 0.912874043, green: 0.7847792506, blue: 0.7251357436, alpha: 1)
      configureAutoLayout()
      
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    fitToScrollView()
  }
  
  
  
  private func fitToScrollView() {
    let zoomScale = (scrollView.frame.size.width) / (imageView.image!.size.width)
    
    print("(scrollView.frame.size.width)", (scrollView.frame.size.width))
    print("(imageView.image!.size.width)", (imageView.image!.size.width))
    print("scrollView.frame.size.width / (imageView.image!.size.width)", scrollView.frame.size.width / (imageView.image!.size.width))
    
    scrollView.setZoomScale(zoomScale, animated: false)
  }
  
  private func configureAutoLayout() {
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }


}


extension MountainVC: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}

