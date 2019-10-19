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
    tb.backgroundColor = UIColor(named: "profileBackground")
    view.addSubview(tb)
    return tb
  }()
  
  private var climbingList: [UserRecord] = [] {
    didSet {
      guard !self.climbingList.isEmpty else {
        self.totalhours = "00:00:00"
        self.totalTimes = "0회"
        self.totalDistance = "0.0km"
        return print("climbingList is empty")
        
      }
      
      var hours: TimeInterval = 0.0
//      var distance: Double = 0.0
      for info in self.climbingList {
        guard let finish = info.finish else { continue }
        hours += finish.timeIntervalSinceReferenceDate - info.start.timeIntervalSinceReferenceDate
//        self.totalTimes = climbingLis
      }
      self.totalhours = "\(hours.asTimeString2())"
      self.totalTimes = "\(self.climbingList.count) 회"
      
      self.totalDistance = "\(String(format: "%0.2f", hours*0.002))km"
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
      }
    }
  }
  
  private var totalTimes: String = ""
  private var totalhours: String = ""
  private var totalDistance: String = ""
  
  private let cellTitles = ["프로필", "나의 등반 기록", "이용약관", "개인정보 보호정책", "위치정보 이용약관", "로그아웃"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(named: "profileBackground")
    
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    setupNavigationBar()
    settingTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UserInfo.def.recordDB?.getAllRecode(complete: { [weak self] (records) in
      
      self?.climbingList = records
    })
    
    self.navigationController?.navigationBar.isHidden = true
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
      cell.separatorInset = UIEdgeInsets.zero
      return cell
    case 1:
       let cell = tableView.dequeue(UserClimbingRecordCell.self)
       cell.separatorInset = UIEdgeInsets.zero
       cell.setupCell(times: self.totalTimes,
                      hour: self.totalhours,
                      distance: self.totalDistance)
      return cell
//    case 2:
//      let cell = tableView.dequeue(DefaultCell.self)
//      cell.mainLabel.text = cellTitles[indexPath.row]
//      cell.markImageView.isHidden = true
//      return cell
    default:
      let cell = tableView.dequeue(DefaultCell.self)
      cell.separatorInset = UIEdgeInsets.zero
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
      let userClimbingList = UserRecordsVC()
      userClimbingList.climbingList = self.climbingList
      self.navigationController?.pushViewController(userClimbingList, animated: true)
//      present(UserRecordsVC(), animated: true, completion: nil)
    case 2:
      let vc = TextViewVC()
      present(vc, animated: true, completion: nil)
      vc.setText(agreement)
      vc.titleLabel.text = "이용약관"
    case 3:
      let vc = TextViewVC()
      present(vc, animated: true, completion: nil)
      vc.setText(security)
      vc.titleLabel.text = "개인정보 보호정책"
    case 4:
      let vc = TextViewVC()
      present(vc, animated: true, completion: nil)
      vc.setText(position)
      vc.titleLabel.text = "위치정보 이용약관"
    case 5:
      self.showAlert()
    default:
      break
    }
  }
}
