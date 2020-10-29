//
//  CustomCategoryView.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/11.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import FFPopup

//extension UIView {
//    func loadView(nibName: String) -> UIView? {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: nibName, bundle: bundle)
//        return nib.instantiate(withOwner: self, options: nil).first as? UIView
//    }
//
//    var mainView: UIView? {
//        return subviews.first
//    }
//}

class CustomCategoryView: XibView {

//    var popup = FFPopup()
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var totalButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var pcButton: UIButton!
    @IBOutlet weak var singButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
      
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .white
        
        totalButton.tag = 0
        foodButton.tag = 1
        cafeButton.tag = 2
        barButton.tag = 3
        pcButton.tag = 4
        singButton.tag = 5
    }
}
