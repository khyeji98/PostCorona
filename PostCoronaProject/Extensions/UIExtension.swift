//
//  UIExtension.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/23.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightImage(image: UIImage) {
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width + 3, height: image.size.height))
        rightImage.image = image
        self.rightView = rightImage
        self.rightViewMode = ViewMode.always
    }
}

