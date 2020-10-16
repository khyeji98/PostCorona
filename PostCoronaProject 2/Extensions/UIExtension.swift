//
//  UIExtension.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/23.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addLeftPadding(_ paddingWidth: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: paddingWidth, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addThreeRightImage(image: UIImage) {
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        rightImage.image = image
        self.rightView = rightImage
        self.rightViewMode = ViewMode.always
    }
    
    func addFarRightImage(image: UIImage) {
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        rightImage.image = image
        self.rightView = rightImage
        self.rightViewMode = ViewMode.always
    }
}
