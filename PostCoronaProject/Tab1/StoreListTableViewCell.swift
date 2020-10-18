//
//  SurroundingStoreListTableViewCell.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/08.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class StoreListTableViewCell: UITableViewCell {

    // 둥근 이미지들 선택했을 때에도 이미지 모양대로 설정해주기
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var safeCountingLabel: UILabel!
    @IBOutlet weak var checkListImageView: UIImageView!
    
    var email: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
