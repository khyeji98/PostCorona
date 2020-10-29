//
//  IsUserView.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/23.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class IsUserView: XibView {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
