//
//  MyStoreViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/24.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class MyStoreViewController: UIViewController {

    var storeName = String()
    var storeNum = String()
    var category = String()

    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedDailyButton(_ sender: UIButton) {
        if let checkListVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckList") as? CheckListViewController
        {
            checkListVC.category = self.category
            checkListVC.storeNum = self.storeNum
            checkListVC.whatData = 0 // daily
            self.navigationController?.pushViewController(checkListVC, animated: true)
        }
    }
    
    @IBAction func tappedReportButton(_ sender: UIButton) {
        if let reportListVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportList") as? ReportListViewController {
            reportListVC.storeNum = self.storeNum
            self.navigationController?.pushViewController(reportListVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storeNameLabel.text = storeName
    }
}
