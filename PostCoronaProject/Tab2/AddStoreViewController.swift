//
//  StoreAdminViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/23.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

protocol AddressSearchDelegate {
    func receiveSeletedAddress(_ selectedAddress: Address?)
}

class AddStoreViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var categoryPickerTextField: UITextField!
    @IBOutlet weak var firstPhoneNumPickerTextField: UITextField!
    @IBOutlet weak var secondPhoneNumTextField: UITextField!
    @IBOutlet weak var corporateRegistrationNumTextField: UITextField!
    @IBOutlet weak var firstAddressLabel: UILabel!
    @IBOutlet weak var secondAddressTextField: UITextField!
    @IBOutlet weak var homepageTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    var storeAddress = Address(jibunAddr: "", roadAddr: "", placeName: "", x: "", y: "")
    var splitAddress:[String] = []
    let picker = UIImagePickerController()
    let storeCategories = ["음식점", "카페", "주점", "PC방", "노래방"]
    let firstPhoneNums = ["02", "031", "032", "041", "042", "043", "044", "051", "052", "053", "054", "055", "061", "062", "063", "064", "010", "011", "016", "017", "019"]
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let pickerView = UIPickerView()
    var activeTextField = 0
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        if let storeName = self.storeNameTextField.text {
            db.collection("storeList").document(storeName).setData([
                "add": self.storeAddress.roadAddr,
                "add1": self.splitAddress[0],
                "add2": self.splitAddress[1],
                "add3": self.splitAddress[2],
                "category": categoryPickerTextField.text!,
                "email": userEmail,
                "phone1": firstPhoneNumPickerTextField.text!,
                "phone2": secondPhoneNumTextField.text!,
                "relief": 0,
                "storeName": storeNameTextField.text!,
                "storeNum": corporateRegistrationNumTextField.text!,
                "uid": userID,
                "url": homepageTextField.text ?? "",
                "x": self.storeAddress.x,
                "y": self.storeAddress.y])
            
            if let userImage = userImageView.image?.pngData() {
                storage.reference(forURL: "gs://together-at001.appspot.com/\(storeName).png").putData(userImage)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerTextField.delegate = self
        categoryPickerTextField.text = storeCategories[0]
        firstPhoneNumPickerTextField.text = firstPhoneNums[0]
        firstPhoneNumPickerTextField.delegate = self
        setUI()
        setGesture()
        createPickerView()
        DispatchQueue.main.async {
            self.setupAddTargetIsNotEmptyTextFields()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func setUI() {
        storeNameTextField.addLeftPadding()
        categoryPickerTextField.addLeftPadding()
        firstPhoneNumPickerTextField.addLeftPadding()
        secondPhoneNumTextField.addLeftPadding()
        corporateRegistrationNumTextField.addLeftPadding()
        secondAddressTextField.addLeftPadding()
        homepageTextField.addLeftPadding()
        
        categoryPickerTextField.addRightImage(image: #imageLiteral(resourceName: "icMoreView"))
        firstPhoneNumPickerTextField.addRightImage(image: #imageLiteral(resourceName: "icMoreView"))
        
        storeNameTextField.layer.borderWidth = 0.8
        categoryPickerTextField.layer.borderWidth = 0.8
        firstPhoneNumPickerTextField.layer.borderWidth = 0.8
        secondPhoneNumTextField.layer.borderWidth = 0.8
        corporateRegistrationNumTextField.layer.borderWidth = 0.8
        firstAddressLabel.layer.borderWidth = 0.8
        secondAddressTextField.layer.borderWidth = 0.8
        homepageTextField.layer.borderWidth = 0.8
        
        storeNameTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        categoryPickerTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        firstPhoneNumPickerTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        secondPhoneNumTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        corporateRegistrationNumTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        firstAddressLabel.layer.borderColor = UIColor.veryLightPink.cgColor
        secondAddressTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        homepageTextField.layer.borderColor = UIColor.veryLightPink.cgColor
        
        userImageView.layer.cornerRadius = 19
    }
    
    func setGesture() {
        // ImageView
        userImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
        userImageView.addGestureRecognizer(imageGesture)
        // Label
        firstAddressLabel.isUserInteractionEnabled = true
        let labelGesture = UITapGestureRecognizer(target: self, action: #selector(tappedLabel(tapGestureRecognizer:)))
        firstAddressLabel.addGestureRecognizer(labelGesture)
    }
    
    func createPickerView() {
        // pickerView
        pickerView.delegate = self
        categoryPickerTextField.inputView = pickerView
        firstPhoneNumPickerTextField.inputView = pickerView
        
        // pickerView_Toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(tappedDone))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        categoryPickerTextField.inputAccessoryView = toolBar
        firstPhoneNumPickerTextField.inputAccessoryView = toolBar
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        okButton.isEnabled = false
        storeNameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
        categoryPickerTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
        secondPhoneNumTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
        corporateRegistrationNumTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
        secondAddressTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        guard
            let storeName = storeNameTextField.text, !storeName.isEmpty,
            let category = categoryPickerTextField.text, !category.isEmpty,
            let secondPhone = secondPhoneNumTextField.text, !secondPhone.isEmpty,
            let register = corporateRegistrationNumTextField.text, !register.isEmpty,
            let secondAddr = secondAddressTextField.text, !secondAddr.isEmpty
            else
        {
                self.okButton.isEnabled = false
                self.okButton.backgroundColor = UIColor.veryLightPink
                return
        }
        okButton.isEnabled = true
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
    
    @objc func tappedDone() {
        self.view.endEditing(true)
    }
    
    @objc func tappedLabel(tapGestureRecognizer: UITapGestureRecognizer) {
        if let addressSearchVC = self.storyboard?.instantiateViewController(withIdentifier: "AddressSearch") as? AddressSearchViewController {
            addressSearchVC.delegate = self
            self.navigationController?.pushViewController(addressSearchVC, animated: true)
        }
    }
}

extension AddStoreViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch activeTextField {
        case 1:
            return storeCategories.count
        case 2:
            return firstPhoneNums.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch activeTextField {
        case 1:
            return storeCategories[row]
        case 2:
            return firstPhoneNums[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch activeTextField {
        case 1:
            categoryPickerTextField.text = storeCategories[row]
            break
        case 2:
            firstPhoneNumPickerTextField.text = firstPhoneNums[row]
            break
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        switch textField {
        case categoryPickerTextField:
            pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView.delegate?.pickerView?(pickerView, didSelectRow: 0, inComponent: 0)
            activeTextField = 1
        case firstPhoneNumPickerTextField:
            pickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView.delegate?.pickerView?(pickerView, didSelectRow: 0, inComponent: 0)
            activeTextField = 2
        default:
            activeTextField = 0
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

extension AddStoreViewController: AddressSearchDelegate {
    
    func receiveSeletedAddress(_ selectedAddress: Address?) {
        if let roadAddr = selectedAddress?.roadAddr, let jibunAddr = selectedAddress?.jibunAddr, let x = selectedAddress?.x, let y = selectedAddress?.y {
            self.firstAddressLabel.text = "    \(roadAddr)"
            self.firstAddressLabel.textColor = .black
            self.firstAddressLabel.font = UIFont.NotoSansKR(type: .regular, size: 15)
            
            DispatchQueue.global().async {
                self.storeAddress.roadAddr = roadAddr
                self.storeAddress.x = x
                self.storeAddress.y = y
            
                self.splitAddress = jibunAddr.split(separator: " ").map { String($0) }
            
                if self.splitAddress[2].hasSuffix("구") {
                    self.splitAddress[1] = "\(self.splitAddress[1]) \(self.splitAddress[2])"
                    self.splitAddress.remove(at: 2)
                }
            }
        }
    }
}
