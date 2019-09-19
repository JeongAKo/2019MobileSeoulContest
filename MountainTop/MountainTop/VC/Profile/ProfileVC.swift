//
//  ProfileVC.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 11/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

  private lazy var tableView: UITableView = {
    let tb = UITableView(frame: .zero, style: .plain)
    tb.register(cell: ProfileMainCell.self)
    tb.register(cell: UserClimbingRecordCell.self)
    tb.register(cell: DefaultCell.self)
    tb.dataSource = self
    tb.delegate = self
    tb.backgroundColor = .clear
    view.addSubview(tb)
    return tb
  }()
  
  private let cellTitles = ["프로필", "나의 등반 기록", "이용약관", "개인정보 보호정책", "위치정보 이용약관", "로그아웃"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    settingTableView()
  }
  
  private func setupNavigationBar() {
    self.navigationController?.popViewController(animated: true)
//    self.navigationController?.navigationBar.isHidden = true
  }
  
  private func settingTableView() {
    
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func showAlert() {
    let alert = UIAlertController(title: "로그아웃", message: "로그아웃을 진행합니다.", preferredStyle: .alert)
    let cancel = UIAlertAction(title: "취소", style: .destructive)
    let ok = UIAlertAction(title: "로그아웃", style: .default) { (action) in
      KOSession.shared()?.logoutAndClose { [weak self] (success, error) -> Void in
        _ = self?.navigationController?.popViewController(animated: true)
      }
    }
    
    alert.addAction(ok)
    alert.addAction(cancel)
    
    self.present(alert, animated: true, completion: nil)
    
  }
}

extension ProfileVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellTitles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeue(ProfileMainCell.self)
      cell.setupCell(url: UserInfo.def.login.profile,
                     name: UserInfo.def.login.name)
      return cell
    case 1:
       let cell = tableView.dequeue(UserClimbingRecordCell.self)
      return cell
    case 2:
      let cell = tableView.dequeue(DefaultCell.self)
      cell.mainLabel.text = cellTitles[indexPath.row]
      cell.markImageView.isHidden = true
      return cell
    default:
      let cell = tableView.dequeue(DefaultCell.self)
      cell.mainLabel.text = cellTitles[indexPath.row]
      cell.markImageView.isHidden = false
      return cell
    }
  }
}

extension ProfileVC: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return 150
    case 1:
      return 150
    default:
      return 70
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case 1:
      self.navigationController?.pushViewController(UserRecordsVC(), animated: true)
//      present(UserRecordsVC(), animated: true, completion: nil)
    case 2:
      self.navigationController?.pushViewController(DBTestVC(), animated: true)
    case 5:
      self.showAlert()
    default:
      break
    }
  }
}
