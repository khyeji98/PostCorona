//
//  CustomCategoryView.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/11.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import FFPopup
import Firebase

extension UIView {
    func loadView(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    var mainView: UIView? {
        return subviews.first
    }
}

class CustomCategoryView: UIView {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var totalButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var pubButton: UIButton!
    @IBOutlet weak var pcButton: UIButton!
    @IBOutlet weak var singButton: UIButton!
    
    var popup : FFPopup?
    
//    @IBAction func tappedTotalButton(_ sender: UIButton) {
//        totalButton.tag = 0
//        totalButton.isSelected = !totalButton.isSelected
//        if totalButton.isSelected == true{
//            cafeButton.isSelected = false
//            foodButton.isSelected = false
//            pubButton.isSelected = false
//            pcButton.isSelected = false
//            singButton.isSelected = false
//        }
//    }
//
//    @IBAction func tappedFoodButton(_ sender: UIButton) {
//        foodButton.tag = 1
//        foodButton.isSelected = !foodButton.isSelected
//        if foodButton.isSelected == true {
//            totalButton.isSelected = false
//            cafeButton.isSelected = false
//            pubButton.isSelected = false
//            pcButton.isSelected = false
//            singButton.isSelected = false
//        }
//    }
//
//    @IBAction func tappedCafeButton(_ sender: UIButton) {
//        cafeButton.tag = 2
//        cafeButton.isSelected = !cafeButton.isSelected
//        if cafeButton.isSelected == true {
//            totalButton.isSelected = false
//            foodButton.isSelected = false
//            pubButton.isSelected = false
//            pcButton.isSelected = false
//            singButton.isSelected = false
//        }
//    }
//
//    @IBAction func tappedPubButton(_ sender: UIButton) {
//        pubButton.tag = 3
//        pubButton.isSelected = !pubButton.isSelected
//        if pubButton.isSelected == true{
//            totalButton.isSelected = false
//            foodButton.isSelected = false
//            cafeButton.isSelected = false
//            pcButton.isSelected = false
//            singButton.isSelected = false
//        }
//    }
//
//    @IBAction func tappedPcButton(_ sender: UIButton) {
//        pcButton.tag = 4
//        pcButton.isSelected = !pcButton.isSelected
//        if pcButton.isSelected == true {
//            totalButton.isSelected = false
//            foodButton.isSelected = false
//            cafeButton.isSelected = false
//            pubButton.isSelected = false
//            singButton.isSelected = false
//        }
//    }
//
//    @IBAction func tappedSingButton(_ sender: UIButton) {
//        singButton.isSelected = !singButton.isSelected
//        if singButton.isSelected == true {
//            totalButton.isSelected = false
//            foodButton.isSelected = false
//            cafeButton.isSelected = false
//            pubButton.isSelected = false
//            pcButton.isSelected = false
//        }
//    }
    
      override init(frame: CGRect) {
          super.init(frame: frame)
          setup()
      }
      
      required init(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)!
          setup()
      }
    
      private func setup() {
        backgroundColor = .white
          
        guard let view = loadView(nibName: "CustomCategoryView") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        totalButton.isSelected = !totalButton.isSelected
        foodButton.isSelected = !foodButton.isSelected
        cafeButton.isSelected = !cafeButton.isSelected
        pubButton.isSelected = !pubButton.isSelected
        pcButton.isSelected = !pcButton.isSelected
        singButton.isSelected = !singButton.isSelected
        
//        if totalButton.isSelected == true{
//            cafeButton.isSelected = false
//            foodButton.isSelected = false
//            pubButton.isSelected = false
//            pcButton.isSelected = false
//            singButton.isSelected = false
//        } else if foodButton.isSelected == true {
//            totalButton.isSelected = false
//            cafeButton.isSelected = false
//            pubButton.isSelected = false
//            pcButton.isSelected = false
//            singButton.isSelected = false
//        } else if cafeButton.isSelected == true {
//            totalButton.isSelected = false
//            foodButton.isSelected = false
//            pubButton.isSelected = false
//            pcButton.isSelected = false
//            singButton.isSelected = false
//        } else if pubButton.isSelected == true{
//            totalButton.isSelected = false
//            foodButton.isSelected = false
//            cafeButton.isSelected = false
//            pcButton.isSelected = false
//            singButton.isSelected = false
//        }else if pcButton.isSelected == true {
//            totalButton.isSelected = false
//            foodButton.isSelected = false
//            cafeButton.isSelected = false
//            pubButton.isSelected = false
//            singButton.isSelected = false
//        }else if singButton.isSelected == true {
//            totalButton.isSelected = false
//            foodButton.isSelected = false
//            cafeButton.isSelected = false
//            pubButton.isSelected = false
//            pcButton.isSelected = false
//        }

//        totalButton.tag = 0
//        foodButton.tag = 1
//        cafeButton.tag = 2
//        pubButton.tag = 3
//        pcButton.tag = 4
//        singButton.tag = 5
      }
}
