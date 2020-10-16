//
//  StoreCheckListViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/20.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class StoreCheckListViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
