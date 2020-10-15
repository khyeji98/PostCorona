//
//  MyPageViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/03.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var firstStoreNameLabel: UILabel!
    @IBOutlet weak var goToLogInButton: UIButton!
    @IBOutlet weak var storeAdminButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    let db = Firestore.firestore().collection("storeList")
    var userStoreArray = [Store]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userStoreArray.removeAll()
        DispatchQueue.main.async {
            self.checkLogInState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        // 다시 로드 or 실시간
        self.userStoreArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkLogInState() {
        if let user = Auth.auth().currentUser {
            guard let email = user.email else { return }
            
            userEmailLabel.isHidden = false
            userEmailLabel.text = user.email?.components(separatedBy: "@")[0]
            firstStoreNameLabel.isHidden = false
            goToLogInButton.isHidden = true
            logOutButton.isHidden = false

            
                self.db.whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let querySnapshot = querySnapshot {
                            self.userStoreArray = querySnapshot.documents.compactMap({Store(dictionary: $0.data())})
                            self.firstStoreNameLabel.text = "대표 업장 : \(self.userStoreArray[0].storeName)"
                            
                        } else {
                            self.firstStoreNameLabel.text = "등록된 업장이 없습니다."
                        }
                    }
                }
            
        } else {
            userEmailLabel.isHidden = true
            firstStoreNameLabel.isHidden = true
            goToLogInButton.isHidden = false
            logOutButton.isHidden = true
            storeAdminButton.isEnabled = true
        }
    }
    
    @IBAction func tappedLogOutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            DispatchQueue.main.async {
                self.checkLogInState()
            }
        }catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func tappedGoToLogInButton(_ sender: UIButton) {
        if let logInVC = self.storyboard?.instantiateViewController(withIdentifier: "logIn") as? LogInViewController {
            self.navigationController?.pushViewController(logInVC, animated: true)
        }
    }
    
    @IBAction func tappedStoreAdminButton(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            if let adminStoreVC = self.storyboard?.instantiateViewController(withIdentifier: "adminStore") as? AdminStoreViewController {
                self.navigationController?.pushViewController(adminStoreVC, animated: true)
            }
        } else {
            if let logInVC =  self.storyboard?.instantiateViewController(withIdentifier: "logIn") as? LogInViewController
            {
                self.navigationController?.pushViewController(logInVC, animated: true)
            }
        }
    }
    
    @IBAction func tappedNoticeButton(_ sender: UIButton) {
        if let noticeVC = self.storyboard?.instantiateViewController(withIdentifier: "notice") {
            self.navigationController?.pushViewController(noticeVC, animated: true)
        }
    }
    
    @IBAction func tappedAlarmButton(_ sender: UIButton) {
        if let alarmVC = self.storyboard?.instantiateViewController(withIdentifier: "alarm"){
            self.navigationController?.pushViewController(alarmVC, animated: true)
        }
    }
    
    @IBAction func tappedHelpButton(_ sender: UIButton) {
        if let helpVC = self.storyboard?.instantiateViewController(withIdentifier: "help"){
            self.navigationController?.pushViewController(helpVC, animated: true)
        }
    }
    
    
}
