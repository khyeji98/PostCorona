//
//  TodayCheckListTableViewCell.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/28.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class TodayCheckListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkListNumLabel: UILabel!
    @IBOutlet weak var checkListLabel: UILabel!
    @IBOutlet weak var checkListDetailLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet var detailLabelAndBottomHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
