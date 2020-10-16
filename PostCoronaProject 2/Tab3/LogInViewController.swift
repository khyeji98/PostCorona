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
    @IBOutlet weak var googleLogInButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    //MARK: IBAction
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedLogInButton(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if user != nil{
                print("login success")
                self?.navigationController?.popViewController(animated: true)
            }else{
                print("login fail")
            }
        }
    }
    
    @IBAction func tappedJoinButton(_ sender: UIButton) {
        if let joinVC = self.storyboard?.instantiateViewController(withIdentifier: "join") as? JoinViewController {
            self.navigationController?.pushViewController(joinVC, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    func setUI() {
        emailTextField.addLeftPadding(19)
        passwordTextField.addLeftPadding(19)
        
        emailTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
        
        emailTextField.layer.borderColor = UIColor.veryLightPinkTwo.cgColor
        passwordTextField.layer.borderColor = UIColor.veryLightPinkTwo.cgColor
        
        logInButton.layer.shadowColor = UIColor.black.cgColor
        joinButton.layer.shadowColor = UIColor.black.cgColor
        googleLogInButton.layer.shadowColor = UIColor.black.cgColor
        
        logInButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        joinButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        googleLogInButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        logInButton.layer.shadowOpacity = 0.1
        joinButton.layer.shadowOpacity = 0.1
        googleLogInButton.layer.shadowOpacity = 0.1
        
        logInButton.layer.shadowRadius = 6
        joinButton.layer.shadowRadius = 6
        googleLogInButton.layer.shadowRadius = 6
        
        emailTextField.layer.cornerRadius = 4
        passwordTextField.layer.cornerRadius = 4
        joinButton.layer.cornerRadius = 4
        logInButton.layer.cornerRadius = 4
        googleLogInButton.layer.cornerRadius = 4
    }
}
