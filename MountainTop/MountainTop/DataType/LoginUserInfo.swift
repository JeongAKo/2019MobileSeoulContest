//
//  LoginUserInfo.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 04/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation

struct LoginUserInfo {
  var name: String
  var email: String
  var id: String
  var password: String
  var profile: String
  
  init(name: String?, email: String?, id: String?, password: String?, profile: String?){
    self.name = name!
    self.email = email!
    self.id = id!
    self.password = password!
    self.profile = profile!
    
  }
  
  init(){
    self.name = ""
    self.email = ""
    self.id = ""
    self.password  = ""
    self.profile  = ""
    
  }
}
