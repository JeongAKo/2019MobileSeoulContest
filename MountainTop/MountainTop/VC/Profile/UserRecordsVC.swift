//
//  UserRecordsVC.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 15/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class UserRecordsVC: UIViewController {
  
  // MARK: - Property
  private lazy var tableView: UITableView = {
    let tb = UITableView(frame: .zero, style: .plain)
    tb.register(cell: RecordCell.self)
    tb.register(cell: VoidCell.self)
    tb.register(cell: RecordImageCell.self)
    tb.register(RecordHeaderView.self, forHeaderFooterViewReuseIdentifier: RecordHeaderView.identifier)
    tb.dataSource = self
    tb.delegate = self
//    tb.backgroundColor = .black
    tb.alwaysBounceVertical = true
    tb.separatorStyle = .none
    view.addSubview(tb)
    return tb
  }()
  
  // MARK: - View life cycle
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    settingTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNotification()
  }
  
  // MARK: - setup control
  private func setupNavigationBar() {
    self.navigationController?.navigationBar.isHidden = true
  }
  
  private func settingTableView() {
    tableView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin/3)
    }
  }
  
  private func setupNotification() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(dismissUserRecordVC(_:)),
                                           name: .dismissVC,
                                           object: nil)
  }
  
  // MARK: - Notification Function
  @objc private func dismissUserRecordVC(_ notification: Notification) {
//    presentingViewController?.dismiss(animated: true, completion: nil)
    self.navigationController?.popViewController(animated: true)
  }
  
}

extension UserRecordsVC: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row % 2 == 0 {
      let cell = tableView.dequeue(RecordCell.self)
      return cell
    } else {
      let cell = tableView.dequeue(VoidCell.self)
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecordHeaderView.identifier)
    
    return header
  }
  
  
}

extension UserRecordsVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row % 2 == 0 {
      return 120
    } else {
      return 10
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 150
  }
}
