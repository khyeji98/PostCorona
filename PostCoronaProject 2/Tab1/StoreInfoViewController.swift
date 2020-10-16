//
//  StoreInfoViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/11.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class StoreInfoViewController: UIViewController, MTMapViewDelegate, CLLocationManagerDelegate {

    // MARK: IBOutlets
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var safeCountingLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var safeButton: UIButton!
    @IBOutlet weak var noCheckListLabel: UILabel!
    @IBOutlet weak var handSanitizerImageView: UIImageView!
    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var twoMeterImageView: UIImageView!
    @IBOutlet weak var disinfectionImageView: UIImageView!
    @IBOutlet weak var staffTrainingImageView: UIImageView!
    @IBOutlet weak var icon06ImageView: UIImageView!
    @IBOutlet weak var icon07ImageView: UIImageView!
    @IBOutlet weak var icon08ImageView: UIImageView!
    @IBOutlet weak var checkListButton: UIButton!
    @IBOutlet weak var userListButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var storeLocationMTMapView: MTMapView!
    
    // MARK: IBOutlets_Constraints
    @IBOutlet var leftToIcon05Constraint: NSLayoutConstraint!
    @IBOutlet var icon07ToIcon08Constraint: NSLayoutConstraint!
    @IBOutlet var icon08ToRightConstraint: NSLayoutConstraint!
    
    var store: Store?
    var phone2: String?
    var phone3: String?
    
    let db: Firestore! = Firestore.firestore()
    var checkResultArray = [Bool]()
    
    var mapView: MTMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let store = store {
            storeNameLabel.text = store.storeName
            safeCountingLabel.text = "안심 스티커 \(store.relief)개"
            addressLabel.text = "\(store.roadAdd1) \(store.roadAdd2)"
            
            self.checkTodayCleaning()
            
            mapView = MTMapView(frame: self.storeLocationMTMapView.bounds)
            if let mapView = mapView {
                mapView.delegate = self
                mapView.baseMapType = .standard
                self.storeLocationMTMapView.addSubview(mapView)
            }
        
            if store.phone1 != "", store.phone2 != "" {
                callButton.imageView?.image = UIImage(named: "callActive.png")
                callButton.isEnabled = true
            }else {
                callButton.imageView?.image = UIImage(named: "call.png")
                callButton.isUserInteractionEnabled = false
            }
        
            DispatchQueue.global().async {
                if store.phone2.count == 7 {
                    let strIndex1 = store.phone2.index(store.phone2.startIndex, offsetBy: 0) ... store.phone2.index(store.phone2.endIndex, offsetBy: -5)
                    let strIndex2 = store.phone2.index(store.phone2.startIndex, offsetBy: 3) ..< store.phone2.index(store.phone2.endIndex, offsetBy: 0)
                    self.phone2 = String(store.phone2[strIndex1])
                    self.phone3 = String(store.phone2[strIndex2])
                } else if store.phone2.count == 8 {
                    let strIndex1 = store.phone2.index(store.phone2.startIndex, offsetBy: 0) ... store.phone2.index(store.phone2.endIndex, offsetBy: -5)
                    let strIndex2 = store.phone2.index(store.phone2.startIndex, offsetBy: 4) ..< store.phone2.index(store.phone2.endIndex, offsetBy: 0)
                    self.phone2 = String(store.phone2[strIndex1])
                    self.phone3 = String(store.phone2[strIndex2]) //*
                }
            }
        
            if store.url != "" {
                homepageButton.imageView?.image = UIImage(named: "homepageActive.png")
                homepageButton.isEnabled = true
            } else {
                homepageButton.imageView?.image = UIImage(named: "homepage.png")
                homepageButton.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.checkResultArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedCallButton(_ sender: Any) {
        if let store = self.store, let phone2 = phone2, let phone3 = phone3 {
            if let call = URL(string: "tel://\(store.phone1)\(phone2)\(phone3)") {
                UIApplication.shared.canOpenURL(call)
            
                let alertController = UIAlertController(title: nil, message: "\(store.phone1)-\(phone2)-\(phone3)", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "전화걸기", style: .default, handler: { _ in
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(call, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(call)
                    }
                })
                let noPressed = UIAlertAction(title: "취소", style: .default, handler: nil)
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
 
    @IBAction func tappedHomepageButton(_ sender: UIButton) {
        if let store = self.store {
            guard let url = URL(string: store.url), UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedSafeButton(_ sender: UIButton!) {
        sender.isSelected = !sender.isSelected
        
        if let store = store {
            let documentRef = self.db.collection("storeList").document(store.storeNum)
            
            if sender.isSelected == true{
                documentRef.setData(["relief":store.relief + 1], merge: true)
            } else {
                documentRef.setData(["relief":store.relief - 1], merge: true)
            }
            
        }
    }
    
    @IBAction func tappedCheckListButton(_ sender: UIButton) {
        guard let store = store else { return }
        if let storeCheckResultVC = self.storyboard?.instantiateViewController(withIdentifier: "storeCheckResult") as? StoreCheckResultViewController {
            
            storeCheckResultVC.storeName = store.storeName
            storeCheckResultVC.category = store.category
            storeCheckResultVC.checkResultArray = self.checkResultArray
            
            self.navigationController?.pushViewController(storeCheckResultVC, animated: true)
        }
    }
    
    @IBAction func tappedUserListButton(_ sender: UIButton) {
        
    }
    
    func checkTodayCleaning() {
        guard let store = store else { return }
        
        self.db.collection("checkList\(store.category.capitalized)").document(store.storeNum).addSnapshotListener() { (querySnapshot, error) in
            if let querySnapshot = querySnapshot, querySnapshot.exists {
                guard let date = querySnapshot.data()?["date"] as? Timestamp else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                // firestore date
                let timeInterval = TimeInterval(integerLiteral: date.seconds)
                let time = Date(timeIntervalSince1970: timeInterval)
                let timeString = dateFormatter.string(from: time)
                // today
                let todayString = dateFormatter.string(from: Date())
                
                if timeString == todayString {
                    self.noCheckListLabel.isHidden = true
                    self.checkImageView.image = UIImage(named: "cleanActive.png")
                    self.checkResultArray = querySnapshot["todayCheck"] as? [Bool] ?? [false]
                    self.handSanitizerImageView.isHidden = false
                    self.maskImageView.isHidden = false
                    self.twoMeterImageView.isHidden = false
                    self.disinfectionImageView.isHidden = false
                    self.staffTrainingImageView.isHidden = false
                    self.icon06ImageView.isHidden = false
                    self.icon07ImageView.isHidden = false
                    self.icon08ImageView.isHidden = false
                    // if보다는 switch
                    print(self.checkResultArray)
                    for num in 0...4 {
                        if self.checkResultArray[num] == true {
                            switch num {
                            case 0:
                                self.handSanitizerImageView.image = UIImage(named: "handSanitizerActive.png")
                            case 1:
                                self.maskImageView.image = UIImage(named: "maskActive.png")
                            case 2:
                                self.twoMeterImageView.image = UIImage(named: "2MActive.png")
                            case 3:
                                self.disinfectionImageView.image = UIImage(named: "disinfectionActive.png")
                            case 4:
                                self.staffTrainingImageView.image = UIImage(named: "educationActive.png")
                            default:
                                return
                            }
                        } else {
                            switch num {
                            case 0:
                                self.handSanitizerImageView.image = UIImage(named: "handSanitizer.png")
                            case 1:
                                self.maskImageView.image = UIImage(named: "mask.png")
                            case 2:
                                self.twoMeterImageView.image = UIImage(named: "2M.png")
                            case 3:
                                self.disinfectionImageView.image = UIImage(named: "disinfection.png")
                            case 4:
                                self.staffTrainingImageView.image = UIImage(named: "education.png")
                            default:
                                return
                            }
                        }
                    }
                    self.setCleanIcon(store.category, result: self.checkResultArray)
                    self.checkListButton.isUserInteractionEnabled = true
                } else {
                    self.noCheckListLabel.isHidden = false
                    self.checkImageView.image = UIImage(named: "clean.png")
                    self.handSanitizerImageView.isHidden = true
                    self.maskImageView.isHidden = true
                    self.twoMeterImageView.isHidden = true
                    self.disinfectionImageView.isHidden = true
                    self.staffTrainingImageView.isHidden = true
                    self.icon06ImageView.isHidden = true
                    self.icon07ImageView.isHidden = true
                    self.icon08ImageView.isHidden = true
                    self.checkListButton.isEnabled = false
                }
            } else {
                self.noCheckListLabel.isHidden = false
                self.checkImageView.image = UIImage(named: "clean.png")
                self.handSanitizerImageView.isHidden = true
                self.maskImageView.isHidden = true
                self.twoMeterImageView.isHidden = true
                self.disinfectionImageView.isHidden = true
                self.staffTrainingImageView.isHidden = true
                self.icon06ImageView.isHidden = true
                self.icon07ImageView.isHidden = true
                self.icon08ImageView.isHidden = true
                self.checkListButton.isEnabled = false
                print("없다")
            }
        }
    }
    
    func setCleanIcon(_ category: String, result: Array<Bool>) {
        switch category {
        case "food", "bar":
            if result[5] == true {
                self.icon06ImageView.image = UIImage(named: "numberActive.png")
            } else {
                self.icon06ImageView.image = UIImage(named: "number.png")
            }
            if result[6] == true {
                self.icon07ImageView.image = UIImage(named: "personalPlateActive.png")
            } else {
                self.icon07ImageView.image = UIImage(named: "personalPlate.png")
            }
            if result[7] == true {
                self.icon08ImageView.image = UIImage(named: "wrappingActive.png")
            } else {
                self.icon08ImageView.image = UIImage(named: "wrapping.png")
            }
        case "cafe":
            if result[5] == true {
                self.icon06ImageView.image = UIImage(named: "kioskActive.png")
            } else {
                self.icon06ImageView.image = UIImage(named: "kiosk.png")
            }
            if result[6] == true {
                self.icon07ImageView.image = UIImage(named: "wrappingActive.png")
            } else {
                self.icon07ImageView.image = UIImage(named: "wrapping.png")
            }
            if result[7] == true {
                self.icon08ImageView.image = UIImage(named: "personalPlateActive.png")
            } else {
                self.icon08ImageView.image = UIImage(named: "personalPlate.png")
            }
        case "pc":
            // test 필요
            self.icon08ImageView.isHidden = true
            self.leftToIcon05Constraint.constant = 82.5
            self.icon08ImageView.image = nil // nil or outlet width = 0
            self.icon07ToIcon08Constraint.constant = 81.5
            self.icon08ToRightConstraint.constant = 0
            if result[5] == true {
                self.icon06ImageView.image = UIImage(named: "trashBiActive.png")
            } else {
                self.icon06ImageView.image = UIImage(named: "trashBi.png")
            }
            if result[6] == true {
                self.icon07ImageView.image = UIImage(named: "listActive.png")
            } else {
                self.icon07ImageView.image = UIImage(named: "list.png")
            }
        case "karaoke":
            if result[5] == true {
                self.icon06ImageView.image = UIImage(named: "trashBiActive.png")
            } else {
                self.icon06ImageView.image = UIImage(named: "trashBi.png")
            }
            if result[6] == true {
                self.icon07ImageView.image = UIImage(named: "micActive.png")
            } else {
                self.icon07ImageView.image = UIImage(named: "mic.png")
            }
            if result[7] == true {
                self.icon08ImageView.image = UIImage(named: "listActive.png")
            } else {
                self.icon08ImageView.image = UIImage(named: "list.png")
            }
        default:
            return
        }
    }
}
