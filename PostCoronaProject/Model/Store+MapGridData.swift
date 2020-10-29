//
//  Store.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/10.
//  Copyright © 2020 김혜지. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct Store {
    var storeName: String
    var add1: String
    var add2: String
    var add3: String
    var roadAdd: String
    var email: String
    var category: String
    var phone1: String
    var phone2: String
    var storeNum: String
    var url: String
    var ownerComment: String
    var date: String
    var covid19Aver: Double
    var sanitationAver: Double
    var etcAver: Double
    var covid19Count: Int
    var sanitationCount: Int
    var etcCount: Int
    var x: String
    var y: String
    
    var dictionary: [String: Any] {
        return [
            "storeName": storeName,
            "add1": add1,
            "add2": add2,
            "add3": add3,
            "roadAdd": roadAdd,
            "email": email,
            "category": category,
            "phone1": phone1,
            "phone2": phone2,
            "storeNum": storeNum,
            "url": url,
            "ownerComment": ownerComment,
            "date": date,
            "covid19Aver": covid19Aver,
            "sanitationAver": sanitationAver,
            "etcAver": etcAver,
            "covid19Count": covid19Aver,
            "sanitationCount": sanitationCount,
            "etcCount": etcCount,
            "x": x,
            "y": y
        ]
    }
}

extension Store: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let storeName = dictionary["storeName"] as? String,
            let add1 = dictionary["add1"] as? String,
            let add2 = dictionary["add2"] as? String,
            let add3 = dictionary["add3"] as? String,
            let roadAdd = dictionary["roadAdd"] as? String,
            let email = dictionary["email"] as? String,
            let category = dictionary["category"] as? String,
            let phone1 = dictionary["phone1"] as? String,
            let phone2 = dictionary["phone2"] as? String,
            let storeNum = dictionary["storeNum"] as? String,
            let url = dictionary["url"] as? String,
            let ownerComment = dictionary["ownerComment"] as? String,
            let date = dictionary["date"] as? String,
            let covid19Aver = dictionary["covid19Aver"] as? Double,
            let sanitationAver = dictionary["sanitationAver"] as? Double,
            let etcAver = dictionary["etcAver"] as? Double,
            let covid19Count = dictionary["covid19Count"] as? Int,
            let sanitationCount = dictionary["sanitationCount"] as? Int,
            let etcCount = dictionary["etcCount"] as? Int,
            let x = dictionary["x"] as? String,
            let y = dictionary["y"] as? String else { return nil }
        self.init(storeName: storeName, add1: add1, add2: add2, add3: add3, roadAdd: roadAdd, email: email, category: category, phone1: phone1, phone2: phone2, storeNum: storeNum, url: url, ownerComment: ownerComment, date: date, covid19Aver: covid19Aver, sanitationAver: sanitationAver, etcAver: etcAver, covid19Count: covid19Count, sanitationCount: sanitationCount, etcCount:etcCount, x: x, y: y)
    }
}

struct MapGridData {
  let re = 6371.00877    // 사용할 지구반경  [ km ]
  let grid = 5.0         // 사용할 지구반경  [ km ]
  let slat1 = 30.0       // 표준위도       [degree]
  let slat2 = 60.0       // 표준위도       [degree]
  let olon = 126.0       // 기준점의 경도   [degree]
  let olat = 38.0        // 기준점의 위도   [degree]
  let xo = 42.0          // 기준점의 X좌표  [격자거리] // 210.0 / grid
  let yo = 135.0         // 기준점의 Y좌표  [격자거리] // 675.0 / grid
}
