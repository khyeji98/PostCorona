//
//  TasteViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/19.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import XLPagerTabStrip

class TasteViewController: UIViewController {

    @IBOutlet weak var storeMap: MKMapView!
    
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

extension TasteViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "맛")
    }
}
