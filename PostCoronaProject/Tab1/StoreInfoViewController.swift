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

    var store: Store?
    var phone2 = String()
    var phone3 = String()
    let db = Firestore.firestore()
    var covidComment: [Any] = []
    var distance = Int()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var homepageButton: UIButton!
    @IBOutlet weak var ownerCommentButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        covidComment.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonBar()
        setData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Disinfection") as! DisinfectionViewController
                let child2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Clean") as! CleanViewController
                let child3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Etc") as! EtcViewController
                
        child1.sendDisinData(num: store!.storeNum, name: store!.storeName, category: store!.category, grade: store!.covid19Aver, count: store!.covid19Count, date: store!.date)
        child2.sendCleanData(num: store!.storeNum, name: store!.storeName, category: store!.category, grade: store!.sanitationAver, count: store!.sanitationCount, date: store!.date)
        child3.sendEtcData(num: store!.storeNum, name: store!.storeName, category: store!.category, address: store!.roadAdd, grade: store!.etcAver, count: store!.etcCount, date: store!.date, longitude: store!.x, latitude: store!.y)
        
        return [child1, child2, child3]
    }
    
    @IBAction func tappedCallButton(_ sender: Any) {
        guard let store = store else { return }
        if store.phone1 == "" {
            guard let call = URL(string: "tel://\(self.phone2)\(self.phone3)") else { return }
            
            UIApplication.shared.canOpenURL(call)
            let alertController = UIAlertController(title: nil, message: "\(store.phone2)-\(phone3)", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "전화걸기", style: .default, handler: { _ in
                if #available(iOS 10, *) {
                    UIApplication.shared.open(call, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(call)
                }
            })
            let noPressed = UIAlertAction(title: "취소", style: .default, handler: { _ in })
            
            alertController.addAction(yesPressed)
            alertController.addAction(noPressed)
            present(alertController, animated: true, completion: nil)
        } else {
            guard let call = URL(string: "tel://\(store.phone1)\(self.phone2)\(self.phone3)") else { return }
            
            UIApplication.shared.canOpenURL(call)
            let alertController = UIAlertController(title: nil, message: "\(store.phone1)-\(store.phone2)-\(phone3)", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "전화걸기", style: .default, handler: { _ in
                if #available(iOS 10, *) {
                    UIApplication.shared.open(call, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(call)
                }
            })
            let noPressed = UIAlertAction(title: "취소", style: .default, handler: { _ in })
            
            alertController.addAction(yesPressed)
            alertController.addAction(noPressed)
            present(alertController, animated: true, completion: nil)
        }
    }
 
    @IBAction func tappedHomepageButton(_ sender: UIButton) {
        guard let store = store else { return }
        guard let url = URL(string: store.url),
            UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func tappedOwnerCommentButton(_ sender: UIButton) {
        guard let store = store else { return }
        
        if let ownerCommentVC = self.storyboard?.instantiateViewController(withIdentifier: "OwnerComment") as? OwnerCommentViewController
        {
            ownerCommentVC.ownerComment = store.ownerComment
            ownerCommentVC.storeNum = store.storeNum
            self.navigationController?.pushViewController(ownerCommentVC, animated: true)
        }
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setData() {
        guard let store = self.store else { return }
        storeNameLabel.text = store.storeName
        distanceLable.text = "\(distance)m"
        reviewLabel.text = "최근 방역리뷰 \(store.covid19Count)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.string(from: Date())
        if store.date == todayDate {
            self.checkImageView.image = UIImage(named: "cleanActive.png")
        }
        
        if store.phone2 == "" {
            callButton.imageView?.image = UIImage(named: "call.png")
            callButton.isUserInteractionEnabled = false
        } else {
            callButton.imageView?.image = UIImage(named: "callActive.png")
            callButton.isEnabled = true
        }
        
        DispatchQueue.global().async {
            if store.phone2.count == 7 {
                let strIndex1 = store.phone2.index(store.phone2.startIndex, offsetBy: 0) ... store.phone2.index(store.phone2.endIndex, offsetBy: -5)
                let strIndex2 = store.phone2.index(store.phone2.startIndex, offsetBy: 3) ..< store.phone2.index(store.phone2.endIndex, offsetBy: 0)
                self.phone3 = String(store.phone2[strIndex2])
                self.phone2 = String(store.phone2[strIndex1])
            } else if store.phone2.count == 8 {
                let strIndex1 = store.phone2.index(store.phone2.startIndex, offsetBy: 0) ... store.phone2.index(store.phone2.endIndex, offsetBy: -5)
                let strIndex2 = store.phone2.index(store.phone2.startIndex, offsetBy: 4) ..< store.phone2.index(store.phone2.endIndex, offsetBy: 0)
                self.phone3 = String(store.phone2[strIndex2])
                self.phone2 = String(store.phone2[strIndex1])
            }
        }
        
        if store.url == "" {
            homepageButton.imageView?.image = UIImage(named: "homepage.png")
            homepageButton.isUserInteractionEnabled = false
        } else {
            homepageButton.imageView?.image = UIImage(named: "homepageActive.png")
            homepageButton.isEnabled = true
        }
        
        if store.ownerComment == "업체의 사장님이라면 '업체 추가' 해주세요:)" {
            ownerCommentButton.imageView?.image = UIImage(named: "comment.png")
        } else {
            ownerCommentButton.imageView?.image = UIImage(named: "commentActive.png")
        }
    }
        
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .veryLightPinkTwo
        settings.style.buttonBarItemBackgroundColor = .white
        
        settings.style.buttonBarItemFont = .NotoSansKR(type: .bold, size: 17)
        settings.style.buttonBarItemTitleColor = .darkBlack
        
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        settings.style.selectedBarHeight = 6.0
        settings.style.selectedBarBackgroundColor = .deepSkyBlue
        
        changeCurrentIndexProgressive = {[weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?,  progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .darkBlack
            newCell?.label.textColor = .deepSkyBlue
        }
    }
}
