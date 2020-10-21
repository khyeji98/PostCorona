//
//  JoinViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/20.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class JoinViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailCheckButton: UIButton!
    @IBOutlet weak var emailOverlapLabel: UILabel!
    @IBOutlet weak var emailWrongFormLabel: UILabel!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var pwNotSameLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    // overlap check
    var emailCheck = false
    // state check
    var emailState = false
    var pwState = false
    var pwCheckState = false
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedEmailCheckButton(_ sender: UIButton) {
        if self.emailState == true {
            Auth.auth().fetchSignInMethods(forEmail: self.emailTextField.text!) { (user, error)  in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if user != nil {
                        self.emailOverlapLabel.isHidden = false
                        self.emailCheck = false
                    } else {
                        self.emailOverlapLabel.isHidden = true
                        self.emailCheck = true
                    }
                }
            }
        } else {
            self.emailCheck = false
            
            let alertController = UIAlertController(title: nil, message: "이메일 형식이 올바르지 않습니다.", preferredStyle: .alert)
            let okPressed = UIAlertAction(title: "확인", style: .default, handler: { _ in })
            alertController.addAction(okPressed)
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        guard let email = self.emailTextField.text else { return }
        guard let pw = self.pwTextField.text else { return }
        
        if self.emailCheck == false {
            let alertController = UIAlertController(title: nil, message: "이메일 중복 체크를 해주세요.", preferredStyle: .alert)
            let okPressed = UIAlertAction(title: "확인", style: .default, handler: { _ in })
            alertController.addAction(okPressed)
            self.present(alertController, animated: true)
        } else {
            // a 수정
            Auth.auth().createUser(withEmail: email, password: pw) { (a, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        registerForKeyboardNotification()
        // setUI
        emailCheckButton.layer.cornerRadius = 4
        emailOverlapLabel.isHidden = true
        emailWrongFormLabel.isHidden = true
        pwNotSameLabel.isHidden = true
        okButton.isEnabled = false
        
        DispatchQueue.main.async {
            self.checkState()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeRegisterForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func checkState() {
        emailTextField.addTarget(self, action: #selector(checkEmail(_:)), for: .editingChanged)
        pwTextField.addTarget(self, action: #selector(checkPwOne(_:)), for: .editingChanged)
        pwCheckTextField.addTarget(self, action: #selector(checkPwTwo(_:)), for: .editingChanged)
        
        if self.emailState == true, self.pwState == true, self.pwCheckState == true, self.emailOverlapLabel.isHidden == true, self.emailWrongFormLabel.isHidden == true, self.pwNotSameLabel.isHidden == true
        {
            self.okButton.isEnabled = true
            self.okButton.backgroundColor = .deepSkyBlue
        } else {
            self.okButton.isEnabled = false
            self.okButton.backgroundColor = .veryLightPink
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: testStr)
    }
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func keyboardAnimate(keyboardRectangle: CGRect, textField: UITextField) {
        if keyboardRectangle.height > (self.view.frame.height - textField.frame.maxY - textField.frame.height) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.height - keyboardRectangle.height - textField.frame.minY))
        }
    }
    
    @objc func checkEmail(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        if let email = sender.text, !email.isEmpty {
            if self.isValidEmail(testStr: email) == true {
                self.emailState = true
                self.emailWrongFormLabel.isHidden = true
            } else {
                self.emailState = false
                self.emailWrongFormLabel.isHidden = false
            }
        } else {
            self.emailState = false
            self.emailWrongFormLabel.isHidden = true
        }
    }
    
    @objc func checkPwOne(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        if let pw = sender.text, !pw.isEmpty {
            self.pwState = true
        } else {
            self.pwState = false
        }
    }
    
    @objc func checkPwTwo(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        if
            let pw = self.pwTextField.text, !pw.isEmpty,
            let pwCheck = sender.text, !pwCheck.isEmpty
        {
            if pw == pwCheck {
                self.pwCheckState = true
            } else {
                self.pwCheckState = false
            }
        } else {
            self.pwState = false
            self.pwCheckState = false
        }
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            if self.emailTextField.isEditing == true {
                self.keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: self.emailTextField)
            } else if self.pwTextField.isEditing == true {
                self.keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: self.pwTextField)
            } else if self.pwCheckTextField.isEditing == true {
                self.keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: self.pwCheckTextField)
            }
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        self.view.transform = .identity
    }
}

extension JoinViewController: UITextFieldDelegate {
    
}
