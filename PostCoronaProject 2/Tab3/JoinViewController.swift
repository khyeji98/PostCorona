//
//  JoinViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/09/12.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class JoinViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailCheckButton: UIButton!
    @IBOutlet weak var emailOverlapCheckLabel: UILabel!
    @IBOutlet weak var emailFormCheckLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var passwordNotSameLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    let db = Firestore.firestore()
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedEmailCheckButton(_ sender: UIButton) {
        if let email = emailTextField.text {
            db.collection("storeList").whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if querySnapshot?.documents.isEmpty == false {
                    self.emailOverlapCheckLabel.isHidden = false
                } else {
                    self.emailOverlapCheckLabel.isHidden = true
                }
                
                if self.isValidEmail(email) == true {
                    self.emailFormCheckLabel.isHidden = true
                } else {
                    self.emailFormCheckLabel.isHidden = false
                }
            }
        } else { return }
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
                
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                    guard self != nil else { return }
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        emailCheckButton.layer.cornerRadius = 4
        emailOverlapCheckLabel.isHidden = true
        emailFormCheckLabel.isHidden = true
        passwordCheckTextField.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: .editingChanged)
        passwordNotSameLabel.isHidden = true
        okButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= keyboardHeight
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRecdtangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRecdtangle.height
            self.view.frame.origin.y += keyboardHeight
        }
    }
    
    @objc func textFieldDidChanged(textField: UITextField) {
        passwordNotSameLabel.isHidden = false
        
        if let password = passwordTextField.text, let passwordCheck = passwordCheckTextField.text {
            if password == passwordCheck {
                passwordNotSameLabel.isHidden = true
                guard let email = emailTextField.text else { return }
                if email.isEmpty == false, emailOverlapCheckLabel.isHidden == true, emailFormCheckLabel.isHidden == true {
                    self.okButton.isEnabled = true
                    self.okButton.backgroundColor = .deepSkyBlue
                }
            } else {
                passwordNotSameLabel.isHidden = false
            }
        }
    }
    
    func isValidEmail(_ sender:String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: sender)
    }
    
}
