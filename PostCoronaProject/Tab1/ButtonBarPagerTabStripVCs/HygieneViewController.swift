//
//  HygieneViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/19.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HygieneViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension HygieneViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "위생")
    }
}
