//
//  LogInAndJoinViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/05.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func setTextField() {
        passwordTextField.isSecureTextEntry = true
    }
    
    //MARK: IBAction
    @IBAction func tappedLogInButton(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            if user != nil{

                print("login success")
                
                guard let nextVC = self?.storyboard?.instantiateViewController(identifier: "StoreList") else { return }
                
                self?.present(nextVC, animated: true)
                    
            }else{
                print("login fail")
            }
        }
    }
    
    @IBAction func tappedJoinButton(_ sender: UIButton) {
        // Auth 넘기기
        guard let email = self.emailTextField.text else {
            return
        }
        guard let password = self.passwordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {(authResut, error) in
            print(error?.localizedDescription as Any)
        
            guard let user = authResut?.user else {
                return
            }
        }
    }
}
