//
//  IsNotView.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/23.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class IsNotUserView: XibView {
    
    @IBOutlet weak var logInButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
