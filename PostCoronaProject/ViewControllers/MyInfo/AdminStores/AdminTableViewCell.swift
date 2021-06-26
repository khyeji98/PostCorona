//
//  MyStoreListTableViewCell.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/09/04.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class AdminTableViewCell: UITableViewCell {

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddrLabel: UILabel!
    @IBOutlet weak var todayCheckImageView: UIImageView!
    @IBOutlet weak var todayReportImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
