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

protocol RegionFilteredDelegate {
    func loadRegionFilterData(_ sender: String)
}

class StoreListViewController: UIViewController, RegionFilteredDelegate {

    let db = Firestore.firestore()
    var storeArray = [Store]()
    
    var filteredStoreArray = [Store]()
    var distanceArray = [Int]()
    var userLocation = CLLocation()
    
    var categoryView = CustomCategoryView()
    var popup = FFPopup()
    var categoryBeforeOK = 0 
    var categoryAfterOK = 0
    
    var selectedRegion = String()
    
    lazy var locationManager: CLLocationManager = { () -> CLLocationManager in
        let manager = CLLocationManager()
        manager.distanceFilter = kCLHeadingFilterNone
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var infecteeNumLabel: UILabel!
    @IBOutlet weak var regionFilterButton: UIButton!
    @IBOutlet weak var categoryFilterButton: UIButton!
    @IBOutlet weak var storeListTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationCheck()
        self.storeListTableView.delegate = self
        self.storeListTableView.dataSource = self
        setUI()
        loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        storeArray.removeAll()
        filteredStoreArray.removeAll()
        distanceArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func filterRegion(_ sender: UIButton) {
        if let regionFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "RegionFilter") as? RegionFilterViewController
        {
            regionFilterVC.delegate = self
            regionFilterVC.modalPresentationStyle = .fullScreen
            self.present(regionFilterVC, animated: true, completion: nil)
        }
    }
    
    @objc func tappedCancelButton() {
        popup.dismiss(animated: true)
    }
    
    @objc func selectCategory(_ sender: UIButton) {
        categoryBeforeOK = sender.tag
        setPopup(categoryBeforeOK)
    }
    
    @objc func tappedOkButton() {
        popup.dismissType = .slideOutToTop.self
        popup.dismiss(animated: true)
        
        categoryAfterOK = categoryBeforeOK
        
        switch categoryAfterOK {
        case 0:
            loadCategoryFilterData("total")
            categoryFilterButton.setTitle("카테고리: 전체", for: .normal)
        case 1:
            loadCategoryFilterData("food")
            categoryFilterButton.setTitle("카테고리: 음식점", for: .normal)
        case 2:
            loadCategoryFilterData("cafe")
            categoryFilterButton.setTitle("카테고리: 카페", for: .normal)
        case 3:
            loadCategoryFilterData("bar")
            categoryFilterButton.setTitle("카테고리: 주점", for: .normal)
        case 4:
            loadCategoryFilterData("pc")
            categoryFilterButton.setTitle("카테고리: PC방", for: .normal)
        case 5:
            loadCategoryFilterData("karaoke")
            categoryFilterButton.setTitle("카테고리: 노래방", for: .normal)
        default:
            loadCategoryFilterData("total")
            categoryFilterButton.setTitle("카테고리: 404", for: .normal)
        }
        DispatchQueue.main.async {
            self.storeListTableView.reloadData()
        }
    }
    
    func setUI() {
        regionFilterButton.layer.cornerRadius = 4
        regionFilterButton.layer.borderColor = UIColor.veryLightPinkTwo.cgColor
        regionFilterButton.layer.borderWidth = 1
        regionFilterButton.setTitle("지역: 전체", for: .normal)
        categoryFilterButton.layer.cornerRadius = 4
        categoryFilterButton.layer.borderColor = UIColor.veryLightPinkTwo.cgColor
        categoryFilterButton.layer.borderWidth = 1
        categoryView.totalButton.setTitleColor(.clearBlue, for: .normal)
        categoryFilterButton.setTitle("카테고리: 전체", for: .normal)
        
    }
    
    func setPopup(_ sender: Int) {
        switch sender {
        case 0:
            categoryView.totalButton.setTitleColor(.clearBlue, for: .normal)
            categoryView.foodButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.cafeButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.barButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.pcButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.singButton.setTitleColor(.brownGrayTwo, for: .normal)
        case 1:
            categoryView.totalButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.foodButton.setTitleColor(.clearBlue, for: .normal)
            categoryView.cafeButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.barButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.pcButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.singButton.setTitleColor(.brownGrayTwo, for: .normal)
        case 2:
            categoryView.totalButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.foodButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.cafeButton.setTitleColor(.clearBlue, for: .normal)
            categoryView.barButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.pcButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.singButton.setTitleColor(.brownGrayTwo, for: .normal)
        case 3:
            categoryView.totalButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.foodButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.cafeButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.barButton.setTitleColor(.clearBlue, for: .normal)
            categoryView.pcButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.singButton.setTitleColor(.brownGrayTwo, for: .normal)
        case 4:
            categoryView.totalButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.foodButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.cafeButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.barButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.pcButton.setTitleColor(.clearBlue, for: .normal)
            categoryView.singButton.setTitleColor(.brownGrayTwo, for: .normal)
        case 5:
            categoryView.totalButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.foodButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.cafeButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.barButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.pcButton.setTitleColor(.brownGrayTwo, for: .normal)
            categoryView.singButton.setTitleColor(.clearBlue, for: .normal)
        default:
            return
        }
    }
    
    // 처음, 전체 업장 데이터 가져옴
    func loadData() {
            self.db.collection("store").getDocuments() { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    self.storeArray = querySnapshot!.documents.compactMap({Store(dictionary: $0.data())})
                    self.categoryBeforeOK = 0
                    self.resortStore(self.userLocation, data: self.storeArray)
                    print(self.userLocation)
                    print(self.storeArray)
                    DispatchQueue.main.async {
                        self.storeListTableView.reloadData()
                    }
                }
            }
        
    }
    // 정렬
    func resortStore(_ location: CLLocation, data: [Store]) {
        DispatchQueue.global().async {
            self.distanceArray.removeAll()
            self.filteredStoreArray.removeAll()
        self.filteredStoreArray = data.sorted {Int(CLLocation(latitude: ($0.y as NSString).doubleValue, longitude: ($0.x as NSString).doubleValue).distance(from: location)) <  Int(CLLocation(latitude: ($1.y as NSString).doubleValue, longitude: ($1.x as NSString).doubleValue).distance(from: location))}
        self.distanceArray = data.map{Int(CLLocation(latitude: ($0.y as NSString).doubleValue, longitude: ($0.x as NSString).doubleValue).distance(from: location))}
        }
    }
    // 카테고리 필터 업장
    func loadCategoryFilterData(_ sender: String) {
        if sender != "total" {
            resortStore(userLocation, data: filteredStoreArray.filter{$0.category == sender})
            DispatchQueue.main.async {
                self.storeListTableView.reloadData()
            }
        } else {
            resortStore(userLocation, data: self.storeArray)
            DispatchQueue.main.async {
                self.storeListTableView.reloadData()
            }
        }
        
    }
    // 지역 필터 업장
    func loadRegionFilterData(_ sender: String) {
        DispatchQueue.global().async {
        if sender != "total" {
                self.resortStore(self.userLocation, data: self.filteredStoreArray.filter{$0.roadAdd.contains(sender)})
                DispatchQueue.main.async {
                    self.storeListTableView.reloadData()
                    self.regionFilterButton.setTitle("지역: \(sender)", for: .normal)
                }
//                self.checkInfecteeCount(String(sender.split(separator: " ")[0]))
//                self.checkInfecteeCount(sender)
        } else {
            self.resortStore(self.userLocation, data: self.storeArray)
//            self.checkInfecteeCount("검역")
        }
//            self.calculateDistance(location: self.userLocation, data: self.filteredStoreArray)
            
            
            DispatchQueue.main.async {
                self.storeListTableView.reloadData()
                self.regionFilterButton.setTitle("지역: 전체", for: .normal)
            }
        }
    }
    
    // 감염자 확인 db
    func checkInfecteeCount(_ region: String) {
            let first = region.index(region.startIndex, offsetBy: 0)
            let end = region.index(region.startIndex, offsetBy: 2)
        DispatchQueue.main.async {
            self.regionLabel.text = region
        }
            self.db.collection("coronic").document("\(region[first..<end])").getDocument()
            { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    guard let querySnapshot = querySnapshot else { return }
                    DispatchQueue.main.async {
                        self.infecteeNumLabel.text = querySnapshot.get("coronic") as? String
                    }
                }
            }
        }
}

extension StoreListViewController: CLLocationManagerDelegate {
    func locationCheck() {
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alertController = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정 화면으로 돌아가시겠습니까? \n '아니오'를 선택하시면 앱이 종료됩니다.", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "네", style: .default) { action in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                } else {
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
            }
            let noPressed = UIAlertAction(title: "아니오", style: .destructive) { action in
                exit(0)
            }
            alertController.addAction(yesPressed)
            alertController.addAction(noPressed)
            self.present(alertController, animated: true, completion: nil)
        }
        else if status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[locations.count - 1]
        let longitude: CLLocationDegrees = location.coordinate.longitude
        let latitude: CLLocationDegrees = location.coordinate.latitude
        let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        self.userLocation = findLocation
        resortStore(findLocation, data: storeArray)
        
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
            if let address: [CLPlacemark] = place {
                self.checkInfecteeCount(String(describing: address.last?.administrativeArea) )
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            let alertController = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정 화면으로 돌아가시겠습니까? \n '아니오'를 선택하시면 앱이 종료됩니다.", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "네", style: .default) { action in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                } else {
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
            }
            let noPressed = UIAlertAction(title: "아니오", style: .destructive) { action in
                exit(0)
            }
            alertController.addAction(yesPressed)
            alertController.addAction(noPressed)
            self.present(alertController, animated: true, completion: nil)
        }
//        else if status == CLAuthorizationStatus.authorizedAlways {
//
//        } else if status == CLAuthorizationStatus.authorizedWhenInUse {
//                   //앱실행중일시
//        }
    }
}

extension StoreListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStoreArray.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListTableViewCell", for: indexPath) as! StoreListTableViewCell
        let store = filteredStoreArray[indexPath.row]
            
        cell.storeImageView.layer.borderWidth = 0.8
        cell.storeImageView.layer.borderColor = UIColor.veryLightPink.cgColor
        cell.storeImageView.layer.cornerRadius = 19
        
        cell.storeImageView.image = UIImage(named: "default.png")
        cell.storeNameLabel.text = store.storeName
        cell.storeAddressLabel.text = "\(store.add1) \(store.add2) \(store.add3)"
        cell.covidAverLabel.text = "\(Int(store.covid19Aver))"
        cell.sanitationAverLabel.text = "\(Int(store.sanitationAver))"
        cell.etcGradeLabel.text = "\(Int(store.etcAver))"
        cell.sanitationCountLabel.text = "(\(store.sanitationCount))"
        cell.covidCountLabel.text = "(\(store.covid19Count))"
        cell.etcCountLabel.text = "(\(store.etcCount))"
        cell.distanceLabel.text = "\(Int(distanceArray[indexPath.row]/10000))m"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.string(from: Date())
        
        if store.date == todayDate {
            cell.todayCheckImageView.image = UIImage(named: "cleanCheckActive.png")
        }

        Storage.storage().reference(forURL: "gs://together-at001.appspot.com/\(store.storeNum).png").downloadURL(completion: { (url, error) in
            if let url = url {
                cell.storeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default.png"))
            }
        })
        return cell
    }
}

extension StoreListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let storeInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreInfo") as? StoreInfoViewController
        {
            storeInfoVC.store = filteredStoreArray[indexPath.row]
            storeInfoVC.distance = distanceArray[indexPath.row]
            self.navigationController?.pushViewController(storeInfoVC, animated: true)
        }
    }
}

