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
    func receiveSelectedAddress(_ selectedAddress: Address?)
}

class AddStoreViewController: UIViewController, UITextFieldDelegate {
    
    var storeAddress = Address(jibunAddr: "", roadAddr: "", placeName: "", x: "", y: "")
    var splitAddress:[String] = []
    let picker = UIImagePickerController()
    let storeCategories = ["음식점", "카페", "주점", "PC방", "노래방"]
    let firstPhoneNums = ["해당없음", "02", "031", "032", "041", "042", "043", "044", "051", "052", "053", "054", "055", "061", "062", "063", "064", "010", "011", "016", "017", "019"]
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let categoryPickerView = UIPickerView()
    let phonePickerView = UIPickerView()
    var activeTextField = 0
    var edit = Bool()
    var store: Store?
    var phone1 = String()
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var categoryPickerTextField: UITextField!
    @IBOutlet weak var firstPhoneNumPickerTextField: UITextField!
    @IBOutlet weak var secondPhoneNumTextField: UITextField!
    @IBOutlet weak var corporateRegistrationNumTextField: UITextField!
    @IBOutlet weak var firstAddressTextField: UITextField!
    @IBOutlet weak var secondAddressTextField: UITextField!
    @IBOutlet weak var homepageTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedNextButton(_ sender: UIButton) {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        
        if firstPhoneNumPickerTextField.text! == "해당없음" {
            phone1 = ""
        } else {
            phone1 = firstPhoneNumPickerTextField.text!
        }
        DispatchQueue.global().async {
            if let storeNum = self.corporateRegistrationNumTextField.text {
                self.db.collection("store").document(storeNum).setData([
                    "roadAdd": "\(self.firstAddressTextField.text!) \(self.secondAddressTextField.text!)",
                    "add1": self.splitAddress[0],
                    "add2": self.splitAddress[1],
                    "add3": self.splitAddress[2],
                    "category": self.categoryPickerTextField.text!,
                    "email": userEmail,
                    "distance": 0,
                    "phone1": self.phone1,
                    "phone2": self.secondPhoneNumTextField.text!,
                    "ownerComment": "",
                    "storeName": self.storeNameTextField.text!,
                    "storeNum": self.corporateRegistrationNumTextField.text!,
                    "url": self.homepageTextField.text ?? "",
                    "x": self.storeAddress.x,
                    "y": self.storeAddress.y,
                    "date": "0000-00-00",
                    "covid19Count": 0,
                    "covid19Aver": 0,
                    "sanitationCount": 0,
                    "sanitationAver": 0,
                    "etcCount": 0,
                    "etcAver": 0
                ], merge: true)
                //MARK: - 이미지 경로 겹쳐도 되는지 확인 요망
//                if let userImage = self.storeImageView.image?.pngData() {
//                    storage.reference(forURL: "gs://together-at001.appspot.com/\(storeNum).png").putData(userImage)
//                }
            }
        }

        if let checkListVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckList") as? CheckListViewController
        {
            checkListVC.whatData = 1 // once, "2 = daily"
            checkListVC.edit = false // 새로 추가
            checkListVC.category = categoryPickerTextField.text!
            self.navigationController?.pushViewController(checkListVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if edit == true {
            setData()
        }
        categoryPickerTextField.delegate = self
        categoryPickerTextField.text = storeCategories[0]
        firstPhoneNumPickerTextField.text = firstPhoneNums[0]
        firstPhoneNumPickerTextField.delegate = self
        setUI()
        setGesture()
        createPickerView()
        DispatchQueue.main.async {
            self.checkTextField()
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
        firstAddressTextField.addLeftPadding()
        secondAddressTextField.addLeftPadding()
        homepageTextField.addLeftPadding()
        
        categoryPickerTextField.addRightImage(image: #imageLiteral(resourceName: "icMoreView"))
        firstPhoneNumPickerTextField.addRightImage(image: #imageLiteral(resourceName: "icMoreView"))
        firstAddressTextField.addRightImage(image: #imageLiteral(resourceName: "icArrowNext"))
        
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
        
        storeImageView.layer.cornerRadius = 19
//        firstAddressTextField.isEnabled = false
    }
    
    func setData() {
        guard let store = store else { return }
        storeNameTextField.text = store.storeName
        categoryPickerTextField.text = store.category
        firstPhoneNumPickerTextField.text = store.phone1
        secondPhoneNumTextField.text = store.phone2
        corporateRegistrationNumTextField.text = store.storeNum
        firstAddressTextField.text = store.roadAdd
//        secondAddressTextField.text = store.roadAdd2
        homepageTextField.text = store.url
    }
    
    func setGesture() {
        // ImageView
        storeImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(tappedUIImageView))
        storeImageView.addGestureRecognizer(imageGesture)
        // TextField
        firstAddressTextField.isUserInteractionEnabled = true
        let textFieldGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAddrSearch(tapGestureRecognizer:)))
        firstAddressTextField.addGestureRecognizer(textFieldGesture)
    }
    
    func createPickerView() {
        // pickerView
        categoryPickerView.delegate = self
        phonePickerView.delegate = self
        categoryPickerTextField.inputView = categoryPickerView
        firstPhoneNumPickerTextField.inputView = phonePickerView
        // pickerView_Toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(tappedDone))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        categoryPickerTextField.inputAccessoryView = toolBar
        firstPhoneNumPickerTextField.inputAccessoryView = toolBar
    }
    
    func checkTextField() {
        nextButton.isEnabled = false
        storeNameTextField.addTarget(self, action: #selector(notEmptyTextField(_:)), for: .editingChanged)
        categoryPickerTextField.addTarget(self, action: #selector(notEmptyTextField(_:)), for: .editingChanged)
        firstAddressTextField.addTarget(self, action: #selector(notEmptyTextField(_:)), for: .editingChanged)
        corporateRegistrationNumTextField.addTarget(self, action: #selector(notEmptyTextField(_:)), for: .editingChanged)
        secondAddressTextField.addTarget(self, action: #selector(notEmptyTextField(_:)), for: .editingChanged)
    }
    
    @objc func notEmptyTextField(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        guard
            let storeName = storeNameTextField.text, !storeName.isEmpty,
            let category = categoryPickerTextField.text, !category.isEmpty,
            let secondPhone = secondPhoneNumTextField.text, !secondPhone.isEmpty,
            let register = corporateRegistrationNumTextField.text, !register.isEmpty,
            let firstAddr = firstAddressTextField.text, !firstAddr.isEmpty
        else {
                self.nextButton.isEnabled = false
                self.nextButton.backgroundColor = UIColor.veryLightPink
                return
        }
        nextButton.isEnabled = true
    }
    
    @objc func tappedUIImageView() {
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
    
    @objc func tappedAddrSearch(tapGestureRecognizer: UITapGestureRecognizer) {
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
        
        switch pickerView {
        case categoryPickerView:
            return storeCategories.count
        case phonePickerView:
            return firstPhoneNums.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case categoryPickerView:
            return storeCategories[row]
        case phonePickerView:
            return firstPhoneNums[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case categoryPickerView:
            categoryPickerTextField.text = storeCategories[row]
            break
        case phonePickerView:
            firstPhoneNumPickerTextField.text = firstPhoneNums[row]
            break
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        switch textField {
        case categoryPickerTextField:
            categoryPickerView.selectRow(storeCategories.firstIndex(of: categoryPickerTextField.text!) ?? 0, inComponent: 0, animated: true)
            categoryPickerView.reloadAllComponents()
        case firstPhoneNumPickerTextField:
            categoryPickerView.selectRow(firstPhoneNums.firstIndex(of: firstAddressTextField.text!) ?? 0, inComponent: 0, animated: true)
            categoryPickerView.reloadAllComponents()
        default:
            return
          }
        
    }
}

extension AddStoreViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - 정방형으로만 이미지 받기
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            storeImageView.image = image
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension AddStoreViewController: AddressSearchDelegate {
    
    func receiveSelectedAddress(_ selectedAddress: Address?) {
        if let roadAddr = selectedAddress?.roadAddr, let jibunAddr = selectedAddress?.jibunAddr, let x = selectedAddress?.x, let y = selectedAddress?.y {
            self.firstAddressTextField.text = roadAddr
            self.firstAddressTextField.textColor = .black
            self.firstAddressTextField.font = UIFont.NotoSansKR(type: .regular, size: 15)
            
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
