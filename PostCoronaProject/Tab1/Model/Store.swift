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
    var roadAdd1: String
    var roadAdd2: String
    var add1: String
    var add2: String
    var add3: String
    var email: String
    var category: String
    var phone1: String
    var phone2: String
    var storeNum: String
    var url: String
    var relief: Int
    var x: String
    var y: String
    
    var dictionary: [String: Any] {
        return [
            "storeName": storeName,
            "roadAdd1": roadAdd1,
            "roadAdd2": roadAdd2,
            "add1": add1,
            "add2": add2,
            "add3": add3,
            "email": email,
            "category": category,
            "phone1": phone1,
            "phone2": phone2,
            "storeNum": storeNum,
            "url": url,
            "relief": relief,
            "x": x,
            "y": y
        ]
    }
}

extension Store: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let storeName = dictionary["storeName"] as? String,
            let roadAdd1 = dictionary["roadAdd1"] as? String,
            let roadAdd2 = dictionary["roadAdd2"] as? String,
            let add1 = dictionary["add1"] as? String,
            let add2 = dictionary["add2"] as? String,
            let add3 = dictionary["add3"] as? String,
            let email = dictionary["email"] as? String,
            let category = dictionary["category"] as? String,
            let phone1 = dictionary["phone1"] as? String,
            let phone2 = dictionary["phone2"] as? String,
            let storeNum = dictionary["storeNum"] as? String,
            let url = dictionary["url"] as? String,
            let relief = dictionary["relief"] as? Int,
            let x = dictionary["x"] as? String,
            let y = dictionary["y"] as? String else {
                return nil
        }
        self.init(storeName: storeName, roadAdd1: roadAdd1, roadAdd2: roadAdd2, add1: add1, add2: add2, add3: add3, email: email, category: category, phone1: phone1, phone2: phone2, storeNum: storeNum, url: url, relief: relief, x: x, y: y)
    }
}
