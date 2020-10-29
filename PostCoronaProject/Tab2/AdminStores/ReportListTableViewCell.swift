//
//  ReportListTableViewCell.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/26.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class ReportListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reportImageView: UIImageView!
    @IBOutlet weak var reportTopicLabel: UILabel!
    @IBOutlet weak var reportTimeLabel: UILabel!
    @IBOutlet weak var reportCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
