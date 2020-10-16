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
import CoreLocation
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
    var categoryView = CustomCategoryView()
    var popup : FFPopup?
    var buttonTag: Int = 0
    
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?
    
    //MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.surroudingStoreListTableView.delegate = self
        self.surroudingStoreListTableView.dataSource = self
        
        filterButton.layer.cornerRadius = 4
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = UIColor.veryLightPinkTwo.cgColor
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        latitude = coor?.latitude
        longitude = coor?.longitude
        
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.storeArray.removeAll()
        self.imageURLArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedFilterButton(_ sender: UIButton) {
        
        categoryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 249)
        popup = FFPopup(contentView: categoryView)
        
        popup?.showType = .slideInFromTop
        popup?.maskType = .dimmed
        popup?.dimmedMaskAlpha = 0.5
        popup?.showInDuration = 0.15
        popup?.dismissOutDuration = 0.15
        popup?.shouldDismissOnBackgroundTouch = true
        popup?.shouldDismissOnContentTouch = false
        
        categoryView.totalButton.addTarget(self, action: #selector(selectTotal), for: .touchUpInside)
        categoryView.foodButton.addTarget(self, action: #selector(selectFood), for: .touchUpInside)
        categoryView.cafeButton.addTarget(self, action: #selector(selectCafe), for: .touchUpInside)
        categoryView.barButton.addTarget(self, action: #selector(selectPub), for: .touchUpInside)
        categoryView.pcButton.addTarget(self, action: #selector(selectPc), for: .touchUpInside)
        categoryView.singButton.addTarget(self, action: #selector(selectSing), for: .touchUpInside)
        categoryView.cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        categoryView.okButton.addTarget(self, action: #selector(tappedOkButton), for: .touchUpInside)
        
        let layout = FFpopupLayout(horizontal: .center, vertical: .top)
        popup?.show(layout: layout)
    }
    
    @objc func tappedCancelButton() {
        popup?.dismissType = .slideOutToTop.self
        popup?.dismiss(animated: true)
    }
    
    @objc func selectTotal() {
//        categoryView = CustomCategoryView()
//        categoryView?.totalButton.isSelected = !(categoryView?.totalButton.isSelected)!
//        if categoryView?.totalButton.isSelected == true {
//            categoryView?.totalButton.setTitleColor(.clearBlue, for: .normal)
//            categoryView?.cafeButton.isSelected = false
//            categoryView?.foodButton.isSelected = false
//            categoryView?.pubButton.isSelected = false
//            categoryView?.pcButton.isSelected = false
//            categoryView?.singButton.isSelected = false
//        }

        categoryView.totalButton.setTitleColor(.clearBlue, for: .normal)
        categoryView.foodButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.cafeButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.barButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.pcButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.singButton.setTitleColor(.lightBrownGrey, for: .normal)
        
        storeArray.removeAll()
        print("total is selected")
        loadTotalData()
    }
    
    @objc func selectFood() {
//        categoryView = CustomCategoryView()
//        categoryView?.foodButton.isSelected = !(categoryView?.foodButton.isSelected)!
//        if categoryView?.foodButton.isSelected == true {
//            categoryView?.foodButton.setTitleColor(.clearBlue, for: .normal)
//            categoryView?.totalButton.isSelected = false
//            categoryView?.cafeButton.isSelected = false
//            categoryView?.pubButton.isSelected = false
//            categoryView?.pcButton.isSelected = false
//            categoryView?.singButton.isSelected = false
//        }
        categoryView.totalButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.foodButton.setTitleColor(.clearBlue, for: .normal)
        categoryView.cafeButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.barButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.pcButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.singButton.setTitleColor(.lightBrownGrey, for: .normal)
        
        storeArray.removeAll()
        print("food is selected")
        loadFilteredData("food")
    }
    
    @objc func selectCafe() {
//        categoryView = CustomCategoryView()
//        categoryView?.cafeButton.isSelected = !(categoryView?.cafeButton.isSelected)!
//        if categoryView?.cafeButton.isSelected == true {
//            categoryView?.totalButton.isSelected = false
//            categoryView?.foodButton.isSelected = false
//            categoryView?.pubButton.isSelected = false
//            categoryView?.pcButton.isSelected = false
//            categoryView?.singButton.isSelected = false
//        }
        categoryView.totalButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.foodButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.cafeButton.setTitleColor(.clearBlue, for: .normal)
        categoryView.barButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.pcButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.singButton.setTitleColor(.lightBrownGrey, for: .normal)
        
        storeArray.removeAll()
        print("cafe is selected")
        loadFilteredData("cafe")
    }
    
    @objc func selectPub() {
//        categoryView = CustomCategoryView()
//        categoryView?.pubButton.setTitleColor(.clearBlue, for: .normal)
//        categoryView?.pubButton.isSelected = !(categoryView?.pubButton.isSelected)!
//        if categoryView?.pubButton.isSelected == true {
//
//            categoryView?.totalButton.isSelected = false
//            categoryView?.foodButton.isSelected = false
//            categoryView?.cafeButton.isSelected = false
//            categoryView?.pcButton.isSelected = false
//            categoryView?.singButton.isSelected = false
//        }
        categoryView.totalButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.foodButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.cafeButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.barButton.setTitleColor(.clearBlue, for: .normal)
        categoryView.pcButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.singButton.setTitleColor(.lightBrownGrey, for: .normal)
        
        storeArray.removeAll()
        print("pub is selected")
        loadFilteredData("bar")
    }
    
    @objc func selectPc() {
//        categoryView = CustomCategoryView()
//        categoryView?.pcButton.setTitleColor(.clearBlue, for: .selected)
//        if categoryView?.pcButton.isSelected == true {
//
//            categoryView?.totalButton.isSelected = false
//            categoryView?.foodButton.isSelected = false
//            categoryView?.cafeButton.isSelected = false
//            categoryView?.pubButton.isSelected = false
//            categoryView?.singButton.isSelected = false
//        }
//        categoryView?.pcButton.isSelected = !(categoryView?.pcButton.isSelected)!
        categoryView.totalButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.foodButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.cafeButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.barButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.pcButton.setTitleColor(.clearBlue, for: .normal)
        categoryView.singButton.setTitleColor(.lightBrownGrey, for: .normal)
        
        storeArray.removeAll()
        print("pc is selected")
        loadFilteredData("pc")
    }
    
    @objc func selectSing() {
//        categoryView = CustomCategoryView()
//        categoryView?.singButton.setTitleColor(.clearBlue, for: .selected)
//        if categoryView?.singButton.isSelected == true {
//
//            categoryView?.totalButton.isSelected = false
//            categoryView?.foodButton.isSelected = false
//            categoryView?.cafeButton.isSelected = false
//            categoryView?.pubButton.isSelected = false
//            categoryView?.pcButton.isSelected = false
//        }
//        categoryView?.singButton.isSelected = !(categoryView?.singButton.isSelected)!
        categoryView.totalButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.foodButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.cafeButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.barButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.pcButton.setTitleColor(.lightBrownGrey, for: .normal)
        categoryView.singButton.setTitleColor(.clearBlue, for: .normal)
        
        storeArray.removeAll()
        print("sing is selected")
        loadFilteredData("karaoke")
    }
    
    @objc func tappedOkButton() {
        DispatchQueue.main.async {
            self.surroudingStoreListTableView.reloadData()
        }
        // 노래방 alert
        popup?.dismissType = .slideOutToTop.self
        popup?.dismiss(animated: true)
        
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "내주변")
    }
    
    func loadData() {
        self.surroudingStoreListTableView.delegate = self
        self.surroudingStoreListTableView.dataSource = self
        
        let collectionRef = db.collection("storeList")
        
        collectionRef.addSnapshotListener() { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                print(error!.localizedDescription)
                return
            }
            self.storeArray = querySnapshot.documents.compactMap({Store(dictionary: $0.data())})
            DispatchQueue.main.async {
                self.surroudingStoreListTableView.reloadData()
            }
        }
    }
    
    func loadTotalData() {
        self.surroudingStoreListTableView.delegate = self
        self.surroudingStoreListTableView.dataSource = self
        
        let collectionRef = db.collection("storeList")
        
        collectionRef.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let querySnapshot = querySnapshot else { return }
                self.storeArray = querySnapshot.documents.compactMap({Store(dictionary: $0.data())})
            }
        }
    }
    
    func loadFilteredData(_ sender: String) {
        self.surroudingStoreListTableView.delegate = self
        self.surroudingStoreListTableView.dataSource = self
        
        let collectionRef = db.collection("storeList")
        
        collectionRef.whereField("category", isEqualTo: String(sender)).addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let querySnapshot = querySnapshot else { return }
                self.storeArray = querySnapshot.documents.compactMap({Store(dictionary: $0.data())})
            }
        }
    }
}

//MARK: -tableViewExtensions
extension SurroundingStoreListViewController: UITableViewDataSource, CLLocationManagerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "surroundingStoreCell", for: indexPath) as! GuStoreListTableViewCell
        let store = storeArray[indexPath.row]
        
        if let latitude = self.latitude, let longitude = self.longitude {
            let userCoor = CLLocation(latitude: latitude, longitude: longitude)
            let storeCoor = CLLocation(latitude: Double(store.y)!, longitude: Double(store.x)!)
            
            cell.distanceLabel.text = "\(String(floor(userCoor.distance(from: storeCoor))))m"
        } else {
            cell.distanceLabel.text = "..m"
        }
        
        cell.storeNameLabel.text = store.storeName
        
        cell.storeAddressLabel.text = "\(store.add1) \(store.add2) \(store.add3)"
        cell.safeCountingLabel.text = "안심 스티커 \(store.relief)개"
        
//        cell.checkListImageView.image = UIImage(named: "cleanCheck.png")
        cell.storeImageView.image = UIImage(named: "default.png")
        
        DispatchQueue.main.async {
            self.db.collection("checkList\(store.category.capitalized)").document(store.storeNum).addSnapshotListener() { (querySnapshot, error) in
                if let querySnapshot = querySnapshot, querySnapshot.exists {
                    if let date = querySnapshot.data()?["date"] as? Timestamp {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        // firestore date
                        let timeInterval = TimeInterval(integerLiteral: date.seconds)
                        let time = Date(timeIntervalSince1970: timeInterval)
                        let timeString = dateFormatter.string(from: time)
                        // today
                        let todayString = dateFormatter.string(from: Date())
                        
                        if todayString == timeString {
                            cell.checkListImageView.image = UIImage(named: "cleanCheckActive.png")
                        } else {
                            cell.checkListImageView.image = UIImage(named: "cleanCheck.png")
                        }
                    }
                } else {
                    cell.checkListImageView.image = UIImage(named: "cleanCheck.png")
                }
            }
            
            Storage.storage().reference(forURL: "gs://together-at001.appspot.com/\(store.storeNum).png").downloadURL(completion: { (url, error) in
                if let url = url {
                    cell.storeImageView.sd_setImage(with: url)
                }
            })
        }
        
        cell.storeImageView.layer.cornerRadius = 19
        cell.storeImageView.layer.borderWidth = 0.8
        cell.storeImageView.layer.borderColor = UIColor.veryLightPink.cgColor
        
        cell.storeNameLabel.font = UIFont.NotoSansKR(type: .medium, size: 16)
        cell.distanceLabel.font = UIFont.SFPro(type: .medium, size: 14)
        cell.storeAddressLabel.font = UIFont.AppleSDGothicNeo(type: .medium, size: 12)
        cell.safeCountingLabel.font = UIFont.AppleSDGothicNeo(type: .medium, size: 12)
        
        cell.storeNameLabel.textColor = UIColor.lightBlack
        cell.distanceLabel.textColor = UIColor.brownGrey
        cell.storeAddressLabel.textColor = UIColor.brownGrey
        cell.safeCountingLabel.textColor = UIColor.clearBlue
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension SurroundingStoreListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = storeArray[indexPath.row]
        
        if let storeInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "storeInfo") as? StoreInfoViewController {
            storeInfoVC.store = selected
            // push from presented vc
            let rootVC = UINavigationController(rootViewController: storeInfoVC)
            rootVC.isNavigationBarHidden = true
            
            rootVC.modalPresentationStyle = .fullScreen
            self.present(rootVC, animated: true, completion: nil)
        }
    }
}

//extension SurroundingStoreListViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//
//        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
//
//    }
//}

