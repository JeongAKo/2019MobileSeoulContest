//
//  rankingVC.swift
//
//
//  Created by Daisy on 24/09/2019.
//

import UIKit

extension Notification.Name {
  static let tabbarIndex = Notification.Name("tabbarIndex")
}

class RankingVC: UIViewController, UITabBarControllerDelegate {
  
  // MARK: - Property
  internal var buttonTag = 0
  
  private let notiCenter = NotificationCenter.default
  
  private lazy var startButton: UIButton = {
    let button = UIButton(type: .custom)
    button.backgroundColor = .gray
    button.layer.cornerRadius = button.frame.size.height / 2
    button.clipsToBounds = true
    button.setTitle("1위 탈환 시작", for: .normal)
    button.addTarget(self, action: #selector(didTapStartButton(_:)), for: .touchUpInside)
    view.addSubview(button)
    return button
  }()
  
  private lazy var dismissButton: UIButton = {
    let button = UIButton(type: .custom)
    button.backgroundColor = .white
    button.setImage(UIImage(named: "close"), for: .normal)
    button.addTarget(self, action: #selector(didTapDismissButton(_:)), for: .touchUpInside)
    view.addSubview(button)
    return button
  }()
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.dataSource = self.self
    tableView.delegate = self.self
    tableView.register(cell: RankingTableViewCell.self)
    tableView.rowHeight = 90
    tableView.allowsSelection = false
    tableView.isScrollEnabled = false
    tableView.separatorColor = .clear
    view.addSubview(tableView)
    return tableView
  }()
  
  // MARK: - App Lifecycle
  override func viewDidLoad() {
    tabBarController?.delegate = self
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    
    configureAutoLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    applyDesign()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let tableviewTopMarin = view.frame.height * 0.15
    let dismissMargin = view.frame.size.height * 0.1
    
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
      self?.tableView.snp.updateConstraints {
        $0.top.equalToSuperview().offset(tableviewTopMarin)
      }
      
      self?.dismissButton.snp.updateConstraints {
        $0.bottom.equalToSuperview().inset(dismissMargin)
      }
      self?.view.layoutIfNeeded()
      }, completion: nil)
  }
  
  
  // MARK: - Action Method
  @objc private func didTapStartButton(_ sender: UIButton) {
    // FIXME: - 여기서 바로 AppDelegate로 접근 못하나?
    
    disMissRankingView()
    let nMap = NMapVC()
//    nMap.buttonTag = buttonTag
    print("Tag🎟", buttonTag)
//    print("nMap.buttonTag", nMap.buttonTag)
    let tabbarIndex = 1
    notiCenter.post(name: .tabbarIndex, object: sender, userInfo: ["tabbarIndex" : tabbarIndex])
  }
  
  private func applyDesign() {
    view.layoutIfNeeded()
    
    tableView.layer.cornerRadius = tableView.frame.size.width / 25
    tableView.clipsToBounds = true
    
    startButton.layer.cornerRadius = startButton.frame.size.height / 2
    startButton.clipsToBounds = true
    
    dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
    dismissButton.clipsToBounds = true
  }
  
  
  fileprivate func disMissRankingView() {
    let dismissMarin = view.frame.height
    
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
      self.tableView.snp.updateConstraints {
        $0.top.equalToSuperview().offset(dismissMarin)
      }
      self.dismissButton.snp.updateConstraints {
        $0.bottom.equalToSuperview().offset(dismissMarin)
      }
      
      self.view.layoutIfNeeded()
    }) { _ in
      self.dismiss(animated: false, completion: nil)
    }
  }
  
  @objc private func didTapDismissButton(_ sender: UIButton) {
    disMissRankingView()
  }
  
  
  // MARK: - AutoLayout
  private func configureAutoLayout() {
    let margin = view.frame.size.height * 0.1
    
    tableView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(50)
      $0.top.equalToSuperview().offset(self.view.frame.height)
      $0.height.equalTo(315)
    }
    
    startButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.width.equalTo(tableView.snp.width)
      $0.height.equalToSuperview().multipliedBy(0.07)
    }
    
    dismissButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(startButton.snp.bottom).offset(margin/2)
      $0.width.equalToSuperview().multipliedBy(0.15)
      $0.height.equalTo(dismissButton.snp.width)
      $0.bottom.equalToSuperview().offset(self.view.frame.height)
    }
  }
}

extension RankingVC: UITableViewDataSource, UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "랭킹 순위"
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RankingTableViewCell.identifier, for: indexPath) as! RankingTableViewCell
    return cell
  }
  
}
