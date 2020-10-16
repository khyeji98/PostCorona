//
//  ChildViewController02.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/07.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import FFPopup
import Firebase
import SDWebImage
import XLPagerTabStrip

class SurroundingStoreListViewController: UIViewController,IndicatorInfoProvider {
    
    //MARK: IBOutlets
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var surroudingStoreListTableView: UITableView!
    
    //MARK: Properties/Firebase
    let db: Firestore! = Firestore.firestore()
    var storeArray = [Store]()
    var imageURLArray = [String]()
    
    //MARK: Properties/FFPopup
    var categoryView: CustomCategoryView?
    var popup : FFPopup?
    var buttonTag: Int = 0
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.surroudingStoreListTableView.delegate = self
        self.surroudingStoreListTableView.dataSource = self
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedFilterButton(_ sender: UIButton) {
        categoryView = CustomCategoryView()
        categoryView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 249)
        
        popup = FFPopup(contentView: categoryView!)
        
        popup?.showType = .slideInFromTop
        popup?.maskType = .dimmed
        popup?.dimmedMaskAlpha = 0.5
        popup?.showInDuration = 0.15
        popup?.dismissOutDuration = 0.15
        popup?.shouldDismissOnBackgroundTouch = true
        popup?.shouldDismissOnContentTouch = false
        
        categoryView?.totalButton.addTarget(self, action: #selector(selectTotal), for: .touchUpInside)
        categoryView?.foodButton.addTarget(self, action: #selector(selectFood), for: .touchUpInside)
        categoryView?.cafeButton.addTarget(self, action: #selector(selectCafe), for: .touchUpInside)
        categoryView?.pubButton.addTarget(self, action: #selector(selectPub), for: .touchUpInside)
        categoryView?.pcButton.addTarget(self, action: #selector(selectPc), for: .touchUpInside)
        categoryView?.singButton.addTarget(self, action: #selector(selectSing), for: .touchUpInside)
        categoryView?.cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        categoryView?.okButton.addTarget(self, action: #selector(tappedOkButton), for: .touchUpInside)
        
        let layout = FFpopupLayout(horizontal: .center, vertical: .top)
        popup?.show(layout: layout)
    }
    
    @objc func tappedCancelButton() {
        popup?.dismissType = .slideOutToTop.self
        popup?.dismiss(animated: true)
    }
    
    @objc func selectTotal() {
        categoryView = CustomCategoryView()
        categoryView?.totalButton.isSelected = !(categoryView?.totalButton.isSelected)!
        if categoryView?.totalButton.isSelected == true {
            categoryView?.totalButton.setTitleColor(.clearBlue, for: .normal)
            categoryView?.cafeButton.isSelected = false
            categoryView?.foodButton.isSelected = false
            categoryView?.pubButton.isSelected = false
            categoryView?.pcButton.isSelected = false
            categoryView?.singButton.isSelected = false
        }
        storeArray.removeAll()
        print("total is selected")
        loadData()
    }
    
    @objc func selectFood() {
        categoryView = CustomCategoryView()
//        categoryView?.foodButton.isSelected = !(categoryView?.foodButton.isSelected)!
//        if categoryView?.foodButton.isSelected == true {
//            categoryView?.foodButton.setTitleColor(.clearBlue, for: .normal)
//            categoryView?.totalButton.isSelected = false
//            categoryView?.cafeButton.isSelected = false
//            categoryView?.pubButton.isSelected = false
//            categoryView?.pcButton.isSelected = false
//            categoryView?.singButton.isSelected = false
//        }
        
        storeArray.removeAll()
        print("food is selected")
        loadFilteredData("음식점")
    }
    
    @objc func selectCafe() {
        categoryView = CustomCategoryView()
        categoryView?.cafeButton.isSelected = !(categoryView?.cafeButton.isSelected)!
        if categoryView?.cafeButton.isSelected == true {
            categoryView?.totalButton.isSelected = false
            categoryView?.foodButton.isSelected = false
            categoryView?.pubButton.isSelected = false
            categoryView?.pcButton.isSelected = false
            categoryView?.singButton.isSelected = false
        }
        if categoryView?.cafeButton.titleColor(for: .normal) == UIColor.clearBlue {
            categoryView?.cafeButton.setTitleColor(.lightBrownGrey, for: .normal)
        } else if categoryView?.cafeButton.titleColor(for: .normal) == UIColor.lightBrownGrey {
            categoryView?.cafeButton.setTitleColor(.clearBlue, for: .normal)
        }
        storeArray.removeAll()
        print("cafe is selected")
        loadFilteredData("카페")
    }
    
    @objc func selectPub() {
        categoryView = CustomCategoryView()
        categoryView?.pubButton.setTitleColor(.clearBlue, for: .normal)
        categoryView?.pubButton.isSelected = !(categoryView?.pubButton.isSelected)!
        if categoryView?.pubButton.isSelected == true {
            
            categoryView?.totalButton.isSelected = false
            categoryView?.foodButton.isSelected = false
            categoryView?.cafeButton.isSelected = false
            categoryView?.pcButton.isSelected = false
            categoryView?.singButton.isSelected = false
        }
        storeArray.removeAll()
        print("pub is selected")
        loadFilteredData("주점")
    }
    
    @objc func selectPc() {
        categoryView = CustomCategoryView()
        categoryView?.pcButton.setTitleColor(.clearBlue, for: .selected)
        if categoryView?.pcButton.isSelected == true {
            
            categoryView?.totalButton.isSelected = false
            categoryView?.foodButton.isSelected = false
            categoryView?.cafeButton.isSelected = false
            categoryView?.pubButton.isSelected = false
            categoryView?.singButton.isSelected = false
        }
        categoryView?.pcButton.isSelected = !(categoryView?.pcButton.isSelected)!
        storeArray.removeAll()
        print("pc is selected")
        loadFilteredData("피시방")
    }
    
    @objc func selectSing() {
        categoryView = CustomCategoryView()
        categoryView?.singButton.setTitleColor(.clearBlue, for: .selected)
        if categoryView?.singButton.isSelected == true {
            
            categoryView?.totalButton.isSelected = false
            categoryView?.foodButton.isSelected = false
            categoryView?.cafeButton.isSelected = false
            categoryView?.pubButton.isSelected = false
            categoryView?.pcButton.isSelected = false
        }
        categoryView?.singButton.isSelected = !(categoryView?.singButton.isSelected)!
        storeArray.removeAll()
        print("sing is selected")
        loadFilteredData("노래방")
    }
    
    @objc func tappedOkButton() {
        DispatchQueue.main.async {
            self.surroudingStoreListTableView.reloadData()
        }
        popup?.dismissType = .slideOutToTop.self
        popup?.dismiss(animated: true)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "내주변")
    }
    
    func loadData() {
        storeArray.removeAll()
        self.surroudingStoreListTableView.delegate = self
        self.surroudingStoreListTableView.dataSource = self
        
        let collectionRef = db.collection("storeList")
        
        collectionRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.storeArray = querySnapshot!.documents.compactMap({Store(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.surroudingStoreListTableView.reloadData()
                }
            }
        }
    }
    
    func loadFilteredData(_ sender: String) {
        storeArray.removeAll()
        self.surroudingStoreListTableView.delegate = self
        self.surroudingStoreListTableView.dataSource = self
        
        let collectionRef = db.collection("storeList")
        
        collectionRef.whereField("category", isEqualTo: String(sender)).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.storeArray = querySnapshot!.documents.compactMap({Store(dictionary: $0.data())})
//                DispatchQueue.main.async {
//                    self.surroudingStoreListTableView.reloadData()
//                }
            }
        }
    }
}

//MARK: -tableViewExtensions
extension SurroundingStoreListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surroundingStoreCell", for: indexPath) as! SurroundingStoreListTableViewCell
        let store = storeArray[indexPath.row]
        
        cell.storeNameLabel.text = store.storeName
        cell.storeAddressLabel.text = "\(store.add1) \(store.add2) \(store.add3)"
        cell.safeCountingLabel.text = "안심 스티커 \(store.relief)개"
        cell.email = store.email
        
        cell.storeImageView.image = UIImage(named: "default.png")
        
        _ = Storage.storage().reference(forURL: "gs://together-at001.appspot.com/\(store.storeName).png").downloadURL(completion: { (url, error) in
            if let url = url {
                cell.storeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default.png"))
            }
        })
        
        cell.storeNameLabel.font = UIFont.NotoSansKR(type: .medium, size: 16)
        cell.distanceLabel.font = UIFont.SFPro(type: .medium, size: 14)
        cell.storeAddressLabel.font = UIFont.AppleSDGothicNeo(type: .medium, size: 12)
        cell.safeCountingLabel.font = UIFont.AppleSDGothicNeo(type: .medium, size: 12)
        
        cell.storeNameLabel.textColor = UIColor.lightBlack
        cell.distanceLabel.textColor = UIColor.brownGrey
        cell.storeAddressLabel.textColor = UIColor.brownGrey
        cell.safeCountingLabel.textColor = UIColor.clearBlue
        
        return cell
    }
}

extension SurroundingStoreListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = storeArray[indexPath.row]
        
        if let storeInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "storeInfo") as? StoreInfoViewController {
            
            storeInfoVC.store = selected

            storeInfoVC.modalPresentationStyle = .fullScreen
            self.present(storeInfoVC, animated: true, completion: nil)
        }
    }
}

