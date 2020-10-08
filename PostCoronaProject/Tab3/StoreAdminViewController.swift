//
//  StoreAdminViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/23.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class AddStoreViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var categoryPickerTextField: UITextField!
    @IBOutlet weak var firstPhoneNumPickerTextField: UITextField!
    @IBOutlet weak var secondPhoneNumTextField: UITextField!
    @IBOutlet weak var corporateRegistrationNumTextField: UITextField!
    @IBOutlet weak var firstAddressTextField: UITextField!
    @IBOutlet weak var secondAddressTextField: UITextField!
    @IBOutlet weak var homepageTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    let picker = UIImagePickerController()
    let storeCategories = ["음식점", "카페", "주점", "PC방", "노래방"]
    let firstPhoneNums = ["02", "031", "032", "041", "042", "043", "044", "051", "052", "053", "054", "055", "061", "062", "063", "064", "010", "011", "016", "017", "019"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldUI()
        setImageView()
        createPickerView()
        dismissPickerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func textFieldUI() {
        storeNameTextField.addLeftPadding()
        categoryPickerTextField.addLeftPadding()
        firstPhoneNumPickerTextField.addLeftPadding()
        secondPhoneNumTextField.addLeftPadding()
        corporateRegistrationNumTextField.addLeftPadding()
        firstAddressTextField.addLeftPadding()
        secondAddressTextField.addLeftPadding()
        homepageTextField.addLeftPadding()
        
        categoryPickerTextField.addRightImage(image: #imageLiteral(resourceName: "icMoreView"))
        firstPhoneNumPickerTextField.addRightImage(image: #imageLiteral(resourceName: "icMoreView"))
        
        storeNameTextField.layer.borderWidth = 0.8
        categoryPickerTextField.layer.borderWidth = 0.8
        firstPhoneNumPickerTextField.layer.borderWidth = 0.8
        secondPhoneNumTextField.layer.borderWidth = 0.8
        corporateRegistrationNumTextField.layer.borderWidth = 0.8
        firstAddressTextField.layer.borderWidth = 0.8
        secondAddressTextField.layer.borderWidth = 0.8
        homepageTextField.layer.borderWidth = 0.8
        
        storeNameTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        categoryPickerTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        firstPhoneNumPickerTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        secondPhoneNumTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        corporateRegistrationNumTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        firstAddressTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        secondAddressTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        homepageTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        
    }
    
    func setImageView() {
        userImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
        userImageView.addGestureRecognizer(tapGesture)
        
        userImageView.layer.cornerRadius = 19
    }
    
    @objc func touchToPickPhoto() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Photo album inaccessable", message: "'같이' cannot access the photo album", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        categoryPickerTextField.inputView = pickerView
        firstPhoneNumPickerTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(tappedDone))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        categoryPickerTextField.inputAccessoryView = toolBar
        firstPhoneNumPickerTextField.inputAccessoryView = toolBar
    }
    
    @objc func tappedDone() {
        self.view.endEditing(true)
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        storeNameTextField.delegate = self
//        categoryPickerTextField.delegate = self
//        firstPhoneNumPickerTextField.delegate = self
//        secondAddressTextField.delegate = self
//        corporateRegistrationNumTextField.delegate = self
//        firstAddressTextField.delegate = self
//        secondAddressTextField.delegate = self
//
//        if !storeNameTextField.text!.isEmpty, !categoryPickerTextField.text!.isEmpty, !firstPhoneNumPickerTextField.text!.isEmpty, !secondPhoneNumTextField.text!.isEmpty, !corporateRegistrationNumTextField.text!.isEmpty, !firstAddressTextField.text!.isEmpty, !secondAddressTextField.text!.isEmpty {
//            okButton.isEnabled = true
//        }
//    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddStoreViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if categoryPickerTextField.isTouchInside == true {
            return storeCategories.count
        }
        if firstPhoneNumPickerTextField.isTouchInside == true {
            return firstPhoneNums.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if categoryPickerTextField.isTouchInside == true {
            return storeCategories[row]
        }
        if firstPhoneNumPickerTextField.isTouchInside == true {
            return firstPhoneNums[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if categoryPickerTextField.isTouchInside  == true {
            categoryPickerTextField.text = storeCategories[row]
//            categoryPickerTextField.addTarget(self, action: #selector(tappedDone), for: .touchUpOutside)
        }
        if firstPhoneNumPickerTextField.isTouchInside == true {
            firstPhoneNumPickerTextField.text = firstPhoneNums[row]
        }
    }
}

extension AddStoreViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.image = image
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
