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
    
    var isUser = Bool()
    
    @IBOutlet weak var userStateView: UIView!
    @IBOutlet weak var storeAdminButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var pushButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet var helpAndLogoutHeight: NSLayoutConstraint!
    
    var isUserView: IsUserView?
    var isNotUserView: IsNotUserView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogInState()
    }
    
    override func viewDidLayoutSubviews() {
        self.isUserView?.frame = self.userStateView.bounds
        self.isNotUserView?.frame = self.userStateView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkLogInState() {
        if let user = Auth.auth().currentUser {
            self.logOutButton.isHidden = false
            self.isUserView = IsUserView()
            self.userStateView.addSubview(self.isUserView!)
            self.isUserView!.userNameLabel.text = String(user.email!.split(separator: "@")[0])
            self.isUser = true
        } else {
            self.logOutButton.isHidden = true
            self.helpAndLogoutHeight.constant = 0 - logOutButton.frame.height
            self.isNotUserView = IsNotUserView()
            self.userStateView.addSubview(self.isNotUserView!)
            self.isNotUserView!.logInButton.addTarget(self, action: #selector(tappedLogInButton(_:)), for: .touchUpInside)
            self.isUser = false
        }
        
    }
    
    @IBAction func tappedStoreAdminButton(_ sender: UIButton) {
        guard let adminVC = self.storyboard?.instantiateViewController(withIdentifier: "Admin") as? AdminViewController else { return }
        guard let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogIn") as? LogInViewController else { return }
        
        if isUser == true {
            self.navigationController?.pushViewController(adminVC, animated: true)
        } else {
            logInVC.fromMypage = true
            self.navigationController?.pushViewController(logInVC, animated: true)
        }
    }
    
    @IBAction func tappedNoticeButton(_ sender: UIButton) {
        if let noticeVC = self.storyboard?.instantiateViewController(withIdentifier: "Notice"){
            self.navigationController?.pushViewController(noticeVC, animated: true)
        }
    }
    
    @IBAction func tappedPushButton(_ sender: UIButton) {
        // MARK: - user에게만 push할 수 있는지 확인 필요
        guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "Push") as? PushViewController else { return }
        guard let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "LogIn") as? LogInViewController else{ return }
        
        if isUser == true {
            self.navigationController?.pushViewController(pushVC, animated: true)
        } else {
            logInVC.fromMypage = true
            self.navigationController?.pushViewController(logInVC, animated: true)
        }
    }
    
    @IBAction func tappedHelpButton(_ sender: UIButton) {
        if let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "Help"){
            self.navigationController?.pushViewController(helpVC, animated: true)
        }
    }
    
    @IBAction func tappedLogOutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        viewDidLoad()
    }
    
    @objc func tappedLogInButton(_ sender: UIButton) {
        if let logInVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn") as? LogInViewController
        {
            logInVC.fromMypage = true
            self.navigationController?.pushViewController(logInVC, animated: true)
        }
        
    }
    
}
