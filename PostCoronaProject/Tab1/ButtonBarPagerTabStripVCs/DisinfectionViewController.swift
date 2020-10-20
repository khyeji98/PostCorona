//
//  DisinfectionViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/19.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DisinfectionViewController: UIViewController {

    @IBOutlet weak var reportButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedReportButton(_ sender: UIButton) {
        
    }

}

extension DisinfectionViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "방역")
    }
}
