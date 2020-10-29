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

    var fromMypage = Bool()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if fromMypage == true {
            backButton.setImage(UIImage(named: "icArrowBack.png"), for: .normal)
        } else {
            backButton.setImage(UIImage(named: "icExit.png"), for: .normal)
        }
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
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        if self.fromMypage == true {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedLogInButton(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            if user != nil{
                
                if self?.fromMypage == true {
                    
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    self?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }else{
                let alertController = UIAlertController(title: nil, message: "이메일 또는 비밀번호가 맞지 않습니다.", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(yesPressed)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tappedJoinButton(_ sender: UIButton) {
        if let joinVC = self.storyboard?.instantiateViewController(withIdentifier: "Join") {
            self.navigationController?.pushViewController(joinVC, animated: true)
        }
    }
}
