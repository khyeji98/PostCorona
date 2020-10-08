//
//  EditStoreViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/09/04.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

// pickerview default value setting
class EditStoreViewController: UIViewController {

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var categoryPickerTextField: UITextField!
    @IBOutlet weak var firstPhoneNumPickerTextField: UITextField!
    @IBOutlet weak var secondPhoneNumTextField: UITextField!
    @IBOutlet weak var corporateRegistrationNumTextField: UITextField!
    @IBOutlet weak var firstAddressTextField: UITextField!
    @IBOutlet weak var secondAddressTextField: UITextField!
    @IBOutlet weak var homepageTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    
    var myStore: Store?
    var phone3: String?
    
    var storeAddress = Address(jibunAddr: "", roadAddr: "", placeName: "", x: "", y: "")
    var splitAddress:[String] = []
    
    let imagePicker = UIImagePickerController()
    let storage = Storage.storage()
    
    let storeCategories = ["음식점", "카페", "주점", "PC방", "노래방"]
    let firstPhoneNums = ["02", "031", "032", "041", "042", "043", "044", "051", "052", "053", "054", "055", "061", "062", "063", "064", "010", "011", "016", "017", "019"]
    let categoryPickerView = UIPickerView()
    let firstPhonePickerView = UIPickerView()
    
    let db = Firestore.firestore()
    var category: String?
    

    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        DispatchQueue.global().async {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            guard let userEmail = Auth.auth().currentUser?.email else { return }
            guard let myStore = self.myStore else { return }
            guard let storeImage =  self.storeImageView.image?.pngData() else { return }
            
            switch self.categoryPickerTextField.text! {
            case "음식점":
                self.category = "food"
            case "주점":
                self.category = "bar"
            case "노래방":
                self.category = "karaoke"
            case "피시방":
                self.category = "pc"
            case "카페":
                self.category = "cafe"
            default:
                return
            }
        
            guard let category = self.category else { return }
            self.db.collection("storeList").document(myStore.storeNum).setData([
                "add": "\(self.firstAddressTextField.text!) \(self.secondAddressTextField.text!)",
                "add1": self.splitAddress[0],
                "add2": self.splitAddress[1],
                "add3": self.splitAddress[2],
                "category": category,
                "email": userEmail,
                "phone1": self.firstPhoneNumPickerTextField.text!,
                "phone2": self.secondPhoneNumTextField.text!,
                "relief": 0,
                "storeName": self.storeNameTextField.text!,
                "storeNum": self.corporateRegistrationNumTextField.text!,
                "uid": userID,
                "url": self.homepageTextField.text ?? "",
                "x": self.storeAddress.x,
                "y": self.storeAddress.y], merge: true)
            self.storage.reference(forURL: "gs://together-at001.appspot.com/\(myStore.storeNum).png").putData(storeImage)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let myStore = myStore {
            storeNameTextField.text = myStore.storeName
            categoryPickerTextField.text = myStore.category
            firstPhoneNumPickerTextField.text = myStore.phone1
            secondPhoneNumTextField.text = myStore.phone2
            secondPhoneNumTextField.font = UIFont.NotoSansKR(type: .regular, size: 15)
            corporateRegistrationNumTextField.text = myStore.storeNum
            firstAddressTextField.text = myStore.roadAdd1
            firstAddressTextField.font = UIFont.NotoSansKR(type: .regular, size: 15)
            secondAddressTextField.text = myStore.roadAdd2
            secondPhoneNumTextField.font = UIFont.NotoSansKR(type: .regular, size: 15)
                    
            DispatchQueue.main.async {
                Storage.storage().reference(forURL: "gs://together-at001.appspot.com/\(myStore.storeNum).png").downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let url = url {
                            self.storeImageView.sd_setImage(with: url)
                        }
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setGesture()
        createPickerView()
        
        DispatchQueue.main.async {
            self.setupAddTargetIsNotEmptyTextFields()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.splitAddress.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func setUI() {
        storeNameTextField.addLeftPadding(10)
        categoryPickerTextField.addLeftPadding(10)
        firstPhoneNumPickerTextField.addLeftPadding(10)
        secondPhoneNumTextField.addLeftPadding(10)
        corporateRegistrationNumTextField.addLeftPadding(10)
        firstAddressTextField.addLeftPadding(10)
        secondAddressTextField.addLeftPadding(10)
        homepageTextField.addLeftPadding(10)
        
        categoryPickerTextField.addThreeRightImage(image: #imageLiteral(resourceName: "icMoreView"))
        firstPhoneNumPickerTextField.addThreeRightImage(image: #imageLiteral(resourceName: "icMoreView"))
        firstAddressTextField.addFarRightImage(image: #imageLiteral(resourceName: "icArrowNext"))
        
        storeImageView.layer.cornerRadius = 19
        storeNameTextField.layer.cornerRadius = 1
        categoryPickerTextField.layer.cornerRadius = 1
        firstPhoneNumPickerTextField.layer.cornerRadius = 1
        secondPhoneNumTextField.layer.cornerRadius = 1
        corporateRegistrationNumTextField.layer.cornerRadius = 1
        firstAddressTextField.layer.cornerRadius = 1
        secondAddressTextField.layer.cornerRadius = 1
        homepageTextField.layer.cornerRadius = 1
        
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
    }
    
    func setGesture() {
        // ImageView
        storeImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(touchToPickPhoto))
        storeImageView.addGestureRecognizer(imageGesture)
        // TextField
        firstAddressTextField.isUserInteractionEnabled = true
        let textFieldGesture = UITapGestureRecognizer(target: self, action: #selector(goToSearchAddr(tapGestureRecognizer:)))
        firstAddressTextField.addGestureRecognizer(textFieldGesture)
    }
    
    func createPickerView() {
        // pickerView
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        firstPhonePickerView.delegate = self
        firstPhonePickerView.dataSource = self
        
        categoryPickerTextField.inputView = categoryPickerView
        firstPhoneNumPickerTextField.inputView = firstPhonePickerView
        
        categoryPickerView.tag = 1
        firstPhonePickerView.tag = 2
        
        // pickerView_Toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(tappedDone))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        categoryPickerTextField.inputAccessoryView = toolBar
        firstPhoneNumPickerTextField.inputAccessoryView = toolBar
    }
    
//    func setDefaultValue(_ pickerArr: Array<String>, item: String, inComponenet: Int) {
//        if let indexPosition = pickerArr.firstIndex(of: item) {
//            pickerView.selectRow(indexPosition, inComponent: inComponenet, animated: true)
//        }
//    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        okButton.isEnabled = false
        storeNameTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
        categoryPickerTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
        secondPhoneNumTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
        corporateRegistrationNumTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
        firstAddressTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
        secondAddressTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty(_:)), for: .editingChanged)
    }
    
    @objc func textFieldsIsNotEmpty(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        guard
            let storeName = storeNameTextField.text, !storeName.isEmpty,
            let category = categoryPickerTextField.text, !category.isEmpty,
            let secondPhone = secondPhoneNumTextField.text, !secondPhone.isEmpty,
            let register = corporateRegistrationNumTextField.text, !register.isEmpty,
            let firstAddr = firstAddressTextField.text, !firstAddr.isEmpty,
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
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
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
    
    @objc func goToSearchAddr(tapGestureRecognizer: UITapGestureRecognizer) {
        if let addressSearchVC = self.storyboard?.instantiateViewController(withIdentifier: "addressSearch") as? AddressSearchViewController {
            addressSearchVC.delegate = self
            self.navigationController?.pushViewController(addressSearchVC, animated: true)
        }
    }
}

extension EditStoreViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1:
            return storeCategories.count
        case 2:
            return firstPhoneNums.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return storeCategories[row]
        case 2:
            return firstPhoneNums[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 1:
            categoryPickerTextField.text = storeCategories[row]
        case 2:
            firstPhoneNumPickerTextField.text = firstPhoneNums[row]
        default:
            return
        }
    }
}

extension EditStoreViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            storeImageView.image = image
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension EditStoreViewController: AddressSearchDelegate {
    
    func receiveSeletedAddress(_ selectedAddress: Address?) {
        
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
