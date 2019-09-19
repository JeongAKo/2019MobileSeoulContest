//
//  MountainInfo.swift
//  MountainTop
//
//  Created by CHANGGUEN YU on 18/09/2019.
//  Copyright © 2019 CHANGGUEN YU. All rights reserved.
//

import Foundation

struct MountainInfo: Codable {
  let id: Int
  let name: String
  let infoLat: Double
  let infoLong: Double
  let mtLat: Double
  let mtLong:Double
  let mtAtitude: Double
  let climbingDistance: Double
  let etc: String
}

// sample
let mountainSampleData: Data = """
[
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 1,
    "infoLat" : 37.686098999999999,
    "infoLong" : 127.036238,
    "mtAtitude" : 740,
    "mtLat" : 37.698830000000001,
    "mtLong" : 127.015485,
    "name" : "도봉산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 2,
    "infoLat" : 37.683956000000002,
    "infoLong" : 127.06527,
    "mtAtitude" : 640.5,
    "mtLat" : 37.699055000000001,
    "mtLong" : 127.08125,
    "name" : "수락산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 3,
    "infoLat" : 37.661729999999999,
    "infoLong" : 127.0796,
    "mtAtitude" : 508,
    "mtLat" : 37.663665000000002,
    "mtLong" : 127.09523,
    "name" : "불암산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 4,
    "infoLat" : 37.572237999999999,
    "infoLong" : 127.08772399999999,
    "mtAtitude" : 348.5,
    "mtLat" : 37.571120000000001,
    "mtLong" : 127.095765,
    "name" : "용마산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 5,
    "infoLat" : 37.553550000000001,
    "infoLong" : 127.10075000000001,
    "mtAtitude" : 295.69999999999999,
    "mtLat" : 37.566850000000002,
    "mtLong" : 127.10275,
    "name" : "아차산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 6,
    "infoLat" : 37.475450000000002,
    "infoLong" : 127.05840000000001,
    "mtAtitude" : 306,
    "mtLat" : 37.46895,
    "mtLong" : 127.06155,
    "name" : "구룡산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 7,
    "infoLat" : 37.480350000000001,
    "infoLong" : 127.081,
    "mtAtitude" : 293,
    "mtLat" : 37.474829999999997,
    "mtLong" : 127.07899999999999,
    "name" : "대모산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 8,
    "infoLat" : 37.48245,
    "infoLong" : 127.02124999999999,
    "mtAtitude" : 283,
    "mtLat" : 37.472850000000001,
    "mtLong" : 127.01215000000001,
    "name" : "우면산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 9,
    "infoLat" : 37.4709,
    "infoLong" : 126.97745,
    "mtAtitude" : 632.20000000000005,
    "mtLat" : 37.445210000000003,
    "mtLong" : 126.964125,
    "name" : "관악산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 10,
    "infoLat" : 37.655050000000003,
    "infoLong" : 126.9494,
    "mtAtitude" : 835.5,
    "mtLat" : 37.658700000000003,
    "mtLong" : 126.97799000000001,
    "name" : "북한산(효자동)"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 11,
    "infoLat" : 37.658299999999997,
    "infoLong" : 126.991,
    "mtAtitude" : 835.5,
    "mtLat" : 37.658700000000003,
    "mtLong" : 126.97799000000001,
    "name" : "북한산(우이동)"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 12,
    "infoLat" : 37.592449999999999,
    "infoLong" : 126.9983,
    "mtAtitude" : 342.5,
    "mtLat" : 37.592979999999997,
    "mtLong" : 126.97275,
    "name" : "북악산(한양도성)"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 13,
    "infoLat" : 37.443750000000001,
    "infoLong" : 127.0553,
    "mtAtitude" : 582,
    "mtLat" : 37.427950000000003,
    "mtLong" : 127.0436,
    "name" : "청계산(매봉)"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 14,
    "infoLat" : 37.463700000000003,
    "infoLong" : 126.94799999999999,
    "mtAtitude" : 480.89999999999998,
    "mtLat" : 37.435949999999998,
    "mtLong" : 126.93940000000001,
    "name" : "삼성산"
  },
  {
    "climbingDistance" : 0,
    "etc" : "x",
    "id" : 15,
    "infoLat" : 37.576050000000002,
    "infoLong" : 126.96554999999999,
    "mtAtitude" : 339.80000000000001,
    "mtLat" : 37.584899999999998,
    "mtLong" : 126.95784999999999,
    "name" : "인왕산(사직단)"
  }
]
""".data(using: .utf8)!
