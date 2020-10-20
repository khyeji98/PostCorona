//
//  StoreInfoViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/11.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class StoreInfoViewController: ButtonBarPagerTabStripViewController {

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
//    @IBOutlet weak var storeLocationMTMapView: MKMapView!
    
    var store = Store(storeName: "", add1: "", add2: "", add3: "", roadAdd1: "", roadAdd2: "", email: "", category: "", phone1: "", phone2: "", storeNum: "", url: "", relief: 0, x: "", y: "")
    
    var phone3: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        storeNameLabel.text = store.storeName
        safeCountingLabel.text = "안심 스티커 \(store.relief)개"
//        addressLabel.text = "\(store.roadAdd1) \(store.roadAdd2)"
        
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
                
                self.phone3 = String(self.store.phone2[strIndex2])
                self.store.phone2 = String(self.store.phone2[strIndex1])
            } else if self.store.phone2.count == 8 {
                let strIndex1 = self.store.phone2.index(self.store.phone2.startIndex, offsetBy: 0) ... self.store.phone2.index(self.store.phone2.endIndex, offsetBy: -5)
                let strIndex2 = self.store.phone2.index(self.store.phone2.startIndex, offsetBy: 4) ..< self.store.phone2.index(self.store.phone2.endIndex, offsetBy: 0)
                
                self.phone3 = String(self.store.phone2[strIndex2])
                self.store.phone2 = String(self.store.phone2[strIndex1])
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
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Disinfection") as! DisinfectionViewController
        let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Taste") as! TasteViewController
        let child3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Hygiene") as! HygieneViewController
        
        if self.store.category == "food" || self.store.category == "cafe" || self.store.category == "bar" {
            return [child1, child2, child3]
        } else if self.store.category == "karaoke" || self.store.category == "pc" {
            return [child1, child3]
        }
        
        return []
    }
    
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        
        settings.style.buttonBarItemFont = .NotoSansKR(type: .bold, size: 17)
        settings.style.buttonBarItemTitleColor = .darkBlack
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        settings.style.selectedBarHeight = 5.0
        settings.style.selectedBarBackgroundColor = .deepSkyBlue
        
        changeCurrentIndexProgressive = {[weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,  progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .darkBlack
            newCell?.label.textColor = .deepSkyBlue
        }
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
        self.navigationController?.popViewController(animated: true)
    }
}
