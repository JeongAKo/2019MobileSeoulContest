//
//  RecordHeaderView.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 15/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import UIKit

extension Notification.Name {
  static let dismissVC = Notification.Name("dismissVC")
}

class RecordHeaderView: UITableViewHeaderFooterView {
  
  // MARK: - Property
  static var identifier: String = "RecordHeaderView"
  
  private lazy var dissmissButton: UIButton = {
    let btn = UIButton(type: .custom)
    btn.setImage(UIImage(named: "dismiss"), for: .normal)
    btn.addTarget(self, action: #selector(touchDismissVC(_:)), for: .touchUpInside)
    self.contentView.addSubview(btn)
    return btn
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.text = "나의 등반 기록"
    label.font = UIFont.systemFont(ofSize: FontSize.big, weight: .semibold)
    self.contentView.addSubview(label)
    return label
  }()
  
  // MARK: - View life cycle
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    self.contentView.backgroundColor = .white
    self.backgroundColor = .clear
    autolayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - autolayout
  private func autolayout() {
    dissmissButton.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(Metric.margin/3)
    }
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(dissmissButton.snp.bottom).offset(Metric.margin)
      $0.leading.equalToSuperview().inset(Metric.margin/3)
    }
  }
  
  @objc private func touchDismissVC(_ sender: UIButton) {
    NotificationCenter.default.post(name: .dismissVC, object: nil)
  }
}
