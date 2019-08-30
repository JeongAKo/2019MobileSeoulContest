//
//  ViewController.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 28/08/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  private lazy var loginButton: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setTitle("kakao login", for: .normal)
    btn.backgroundColor = .yellow
    return btn
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
//  private func autolayout 
  
  private func configureView() {
    
  }
}

