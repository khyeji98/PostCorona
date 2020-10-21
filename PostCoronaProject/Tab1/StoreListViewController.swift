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
import CoreLocation // 거리순 정렬

class StoreListViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var regionFilterButton: UIButton!
    @IBOutlet weak var categoryFilterButton: UIButton!
    @IBOutlet weak var storeListTableView: UITableView!
    
    //MARK: Properties/Firebase
    let db: Firestore! = Firestore.firestore()
    var storeArray = [Store]()
    var imageURLArray = [String]()
    
    //MARK: Properties/FFPopup
    var categoryView = CustomCategoryView()
    var popup : FFPopup?
    var currentCategory = 0
    var finalCategory = 0
    
    //MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.storeListTableView.delegate = self
        self.storeListTableView.dataSource = self
        setUI()
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        storeArray.removeAll()
        imageURLArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUI() {
        categoryFilterButton.layer.cornerRadius = 4
        categoryFilterButton.layer.borderColor = UIColor.veryLightPinkTwo.cgColor
        categoryFilterButton.layer.borderWidth = 1
        categoryFilterButton.setTitle("카테고리: 전체", for: .normal)
        categoryView.totalButton.setTitleColor(.clearBlue, for: .normal)
    }
    
    @IBAction func tappedFilterButton(_ sender: UIButton) {
        let layout = FFpopupLayout(horizontal: .center, vertical: .top)
        
        popup = FFPopup(contentView: categoryView)
        if let popup = self.popup {
            popup.show(layout: layout)
            popup.showType = .slideInFromTop
            popup.maskType = .dimmed
            popup.dimmedMaskAlpha = 0.5
            popup.showInDuration = 0.15
            popup.dismissOutDuration = 0.15
            popup.shouldDismissOnBackgroundTouch = true
            popup.shouldDismissOnContentTouch = false
        }
        categoryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 249)
        switch finalCategory {
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
        categoryView.totalButton.addTarget(self, action: #selector(selectCategory(_:)), for: .touchUpInside)
        categoryView.foodButton.addTarget(self, action: #selector(selectCategory(_:)), for: .touchUpInside)
        categoryView.cafeButton.addTarget(self, action: #selector(selectCategory(_:)), for: .touchUpInside)
        categoryView.barButton.addTarget(self, action: #selector(selectCategory(_:)), for: .touchUpInside)
        categoryView.pcButton.addTarget(self, action: #selector(selectCategory(_:)), for: .touchUpInside)
        categoryView.singButton.addTarget(self, action: #selector(selectCategory(_:)), for: .touchUpInside)
        categoryView.cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        categoryView.okButton.addTarget(self, action: #selector(tappedOkButton), for: .touchUpInside)
    }
    
    @objc func tappedCancelButton() {
        if let popup = self.popup {
            popup.dismissType = .slideOutToTop.self
            popup.dismiss(animated: true)
        }
    }
    
    @objc func selectCategory(_ sender: UIButton) {
        currentCategory = sender.tag
        switch currentCategory {
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
    
    @objc func tappedOkButton() {
        finalCategory = currentCategory
        
        if let popup = self.popup {
            popup.dismissType = .slideOutToTop.self
            popup.dismiss(animated: true)
        }
        storeArray.removeAll()
        
        switch finalCategory {
        case 0:
            loadData()
            categoryFilterButton.setTitle("카테고리: 전체", for: .normal)
        case 1:
            loadFilteredData("food")
            categoryFilterButton.setTitle("카테고리: 음식점", for: .normal)
        case 2:
            loadFilteredData("cafe")
            categoryFilterButton.setTitle("카테고리: 카페", for: .normal)
        case 3:
            loadFilteredData("bar")
            categoryFilterButton.setTitle("카테고리: 주점", for: .normal)
        case 4:
            loadFilteredData("pc")
            categoryFilterButton.setTitle("카테고리: PC방", for: .normal)
        case 5:
            loadFilteredData("karaoke")
            categoryFilterButton.setTitle("카테고리: 노래방", for: .normal)
        default:
            loadData()
            categoryFilterButton.setTitle("카테고리: 404", for: .normal)
        }
        
        DispatchQueue.main.async {
            self.storeListTableView.reloadData()
        }
    }
    
    func loadData() {
        storeArray.removeAll()
        
        let collectionRef = db.collection("storeList")
        
        collectionRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.storeArray = querySnapshot!.documents.compactMap({Store(dictionary: $0.data())}) // 거리순
//                print(self.storeArray)
                self.currentCategory = 0
                DispatchQueue.main.async {
                    self.storeListTableView.reloadData()
                }
            }
        }
    }
    
    func loadFilteredData(_ sender: String) {
        storeArray.removeAll()
        
        let collectionRef = db.collection("storeList")
        
        collectionRef.whereField("category", isEqualTo: String(sender)).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.storeArray = querySnapshot!.documents.compactMap({Store(dictionary: $0.data())}) // 거리순
                
                DispatchQueue.main.async {
                    self.storeListTableView.reloadData()
                }
            }
        }
    }
}

//MARK: -tableViewExtensions
extension StoreListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreListTableViewCell", for: indexPath) as! StoreListTableViewCell
        let store = storeArray[indexPath.row]
        
        cell.storeNameLabel.text = store.storeName
        cell.storeAddressLabel.text = "\(store.add1) \(store.add2) \(store.add3)"
//        cell.email = store.email
        
        cell.storeImageView.image = UIImage(named: "default.png")
        
        Storage.storage().reference(forURL: "gs://together-at001.appspot.com/\(store.storeNum).png").downloadURL(completion: { (url, error) in
            if let url = url {
                cell.storeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default.png"))
            }
        })
        
        cell.storeImageView.layer.cornerRadius = 19
        
        cell.storeNameLabel.font = UIFont.NotoSansKR(type: .medium, size: 16)
        cell.distanceLabel.font = UIFont.SFPro(type: .medium, size: 14)
        cell.storeAddressLabel.font = UIFont.AppleSDGothicNeo(type: .medium, size: 12)
        
        cell.storeNameLabel.textColor = UIColor.lightBlack
        cell.distanceLabel.textColor = UIColor.brownGray
        cell.storeAddressLabel.textColor = UIColor.brownGray
        
        return cell
    }
}

extension StoreListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = storeArray[indexPath.row]
        
        if let storeInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreInfo") as? StoreInfoViewController {
            
            storeInfoVC.store = selected

            self.navigationController?.pushViewController(storeInfoVC, animated: true)
        }
    }
}

