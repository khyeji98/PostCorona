//
//  MyPageViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/03.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

protocol RepresentStoreDelegate {
    func receiveStore()
}

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRepresentStoreLabel: UILabel!
    @IBOutlet weak var goToLogInButton: UIButton! // 밑줄 ui
    @IBOutlet weak var storeAdminButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogInState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkLogInState() {
        if Auth.auth().currentUser != nil {
            goToLogInButton.isHidden = true
            // userProfileImageView, userRe는 대표 업장
            
        } else {
            userNameLabel.isHidden = true
            userRepresentStoreLabel.isHidden = true
            storeAdminButton.isEnabled = true
        }
    }
    
    @IBAction func tappedGoToLogInButton(_ sender: UIButton) {
        if let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogIn") {
            self.navigationController?.pushViewController(logInVC, animated: true)
        }
    }
    
    @IBAction func tappedStoreAdminButton(_ sender: UIButton) {
        guard let adminVC = self.storyboard?.instantiateViewController(withIdentifier: "Admin")else{ return }
        guard let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogIn")else{ return }
        
        if Auth.auth().currentUser != nil {
            self.navigationController?.pushViewController(adminVC, animated: true)
        } else {
            self.navigationController?.pushViewController(logInVC, animated: true)
        }
    }
    
    @IBAction func tappedNoticeButton(_ sender: UIButton) {
        if let noticeVC = self.storyboard?.instantiateViewController(withIdentifier: "Notice"){
            self.navigationController?.pushViewController(noticeVC, animated: true)
        }
    }
    
    @IBAction func tappedAlarmButton(_ sender: UIButton) {
        if let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "Push"){
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
    
    @IBAction func tappedHelpButton(_ sender: UIButton) {
        if let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "Help"){
            self.navigationController?.pushViewController(helpVC, animated: true)
        }
    }
    
    
}
