//
//  StoreInfoViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/11.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class StoreInfoViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var safeCountingLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var safeButton: UIButton!
    @IBOutlet weak var handSanitizerImageView: UIImageView!
    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var twoMeterImageView: UIImageView!
    @IBOutlet weak var disinfectionImageView: UIImageView!
    @IBOutlet weak var numberOfPeopleImageView: UIImageView!
    @IBOutlet weak var personalPlateImageView: UIImageView!
    @IBOutlet weak var wrappingImageView: UIImageView!
    @IBOutlet weak var staffTrainingImageView: UIImageView!
    @IBOutlet weak var checkListButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var storeLocationMTMapView: MKMapView!
    
    var store = Store(storeName: "", add: "", add1: "", add2: "", add3: "", email: "", category: "", phone1: "", phone2: "", storeNum: "", url: "", relief: 0, x: "", y: "")
    
    var phone3: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        storeNameLabel.text = store.storeName
        safeCountingLabel.text = "안심 스티커 \(store.relief)개"
        addressLabel.text = store.add
        
        if store.phone1 != "", store.phone2 != "" {
            callButton.imageView?.image = UIImage(named: "callActive.png")
            callButton.isEnabled = true
        }else {
            callButton.imageView?.image = UIImage(named: "call.png")
            callButton.isUserInteractionEnabled = false
        }
        DispatchQueue.global().async {
            if self.store.phone2.count == 7 {
                let strIndex1 = self.store.phone2.index(self.store.phone2.startIndex, offsetBy: 0) ... self.store.phone2.index(self.store.phone2.endIndex, offsetBy: -5)
                let strIndex2 = self.store.phone2.index(self.store.phone2.startIndex, offsetBy: 3) ..< self.store.phone2.index(self.store.phone2.endIndex, offsetBy: 0)
                self.store.phone2 = String(self.store.phone2[strIndex1])
                self.phone3 = String(self.store.phone2[strIndex2])
            } else if self.store.phone2.count == 8 {
                let strIndex1 = self.store.phone2.index(self.store.phone2.startIndex, offsetBy: 0) ... self.store.phone2.index(self.store.phone2.startIndex, offsetBy: -5)
                let strIndex2 = self.store.phone2.index(self.store.phone2.startIndex, offsetBy: 4) ..< self.store.phone2.index(self.store.phone2.endIndex, offsetBy: 0)
                self.store.phone2 = String(self.store.phone2[strIndex1])
                self.phone3 = String(self.store.phone2[strIndex2])
            }
        }
        
        if store.url != "" {
            homepageButton.imageView?.image = UIImage(named: "homepageActive.png")
            homepageButton.isEnabled = true
        }else {
            homepageButton.imageView?.image = UIImage(named: "homepage.png")
            homepageButton.isUserInteractionEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedCallButton(_ sender: Any) {
        
        if let call = URL(string: "tel://\(store.phone1)\(store.phone2)\(phone3)") {
            UIApplication.shared.canOpenURL(call)
            
            let alertController = UIAlertController(title: nil, message: "\(store.phone1)-\(store.phone2)-\(phone3)", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "전화걸기", style: .default, handler: { _ in
                if #available(iOS 10, *) {
                    UIApplication.shared.open(call, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(call)
                }
            })
            let noPressed = UIAlertAction(title: "취소", style: .default, handler: { _ in
                
            })
            alertController.addAction(yesPressed)
            alertController.addAction(noPressed)
            present(alertController, animated: true, completion: nil)
        }
    }
 
    @IBAction func tappedHomepageButton(_ sender: UIButton) {
        guard let url = URL(string: store.url),
            UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCheckListButton(_ sender: UIButton) {
        if let checkListVC = self.storyboard?.instantiateViewController(withIdentifier: "storeCheckList"){
            self.navigationController?.pushViewController(checkListVC, animated: true)
        }
    }
}
