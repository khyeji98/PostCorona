//
//  ResultCell.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/28.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

struct Address {
    var jibunAddr: String
    var roadAddr: String
    var placeName: String
    
    var x: String
    var y: String

}

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var roadAddrLabel: UILabel!
    @IBOutlet weak var jibunAddrLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var item: Address? {
        didSet{
            self.placeNameLabel.text = item?.placeName
            self.roadAddrLabel.text = item?.roadAddr
            self.jibunAddrLabel.text = item?.jibunAddr
        }
    }
    
    var cellDelegate: ResultCellDelegate?
    
}
