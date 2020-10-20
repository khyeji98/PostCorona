//
//  JoinViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/20.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailCheckButton: UIButton!
    @IBOutlet weak var emailOverlapLabel: UILabel!
    @IBOutlet weak var emailWrongFormLabel: UILabel!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var pwNotSameLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailCheckButton.layer.cornerRadius = 4
        emailOverlapLabel.isHidden = true
        emailWrongFormLabel.isHidden = true
        pwNotSameLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedEmailCheckButton(_ sender: UIButton) {
        
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        
        
        
        self.navigationController?.popViewController(animated: true)
    }

}
