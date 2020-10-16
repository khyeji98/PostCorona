//
//  ViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/07/31.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        configureButtonBar()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: XLPagerTabStrip
    func configureButtonBar() {
        settings.style.selectedBarHeight = 0
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarHeight = 61
        
        settings.style.buttonBarItemFont = UIFont.NotoSansKR(type: .bold, size: 17)
        settings.style.buttonBarItemTitleColor = .gray
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
//        PagerTabStripBehaviour.progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: true)
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.veryLightPink
            newCell?.label.textColor = UIColor.darkBlack
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "column") as! ColumnViewController
        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "surroundingStoreList") as! SurroundingStoreListViewController
        let child3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "childViewController03") as! ChildViewController03
        
        return [child1, child2, child3]
    }
    
}

