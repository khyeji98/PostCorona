//
//  PushViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/25.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {

    @IBOutlet weak var pushSwitch: UISwitch!
    
    @IBAction func tappedBackButton(_ sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedSettingButton(_ sender: UIButton) {
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
        } else {
            UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
