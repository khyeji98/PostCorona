//
//  CheckListTableViewCell.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/23.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class DisinListTableViewCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
