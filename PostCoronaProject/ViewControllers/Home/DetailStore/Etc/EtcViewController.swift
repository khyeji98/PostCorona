//
//  TasteViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/19.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
import XLPagerTabStrip

class EtcViewController: UIViewController {

    var address = String()
    var storeNum = String()
    var storeName = String()
    var category = String()
    var longitude = String()
    var latitude = String()
    var grade = Double()
    var commentCount = Int()
    var date = String()
    
    var commentArray = [Any]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var twoImageView: UIImageView!
    @IBOutlet weak var threeImageView: UIImageView!
    @IBOutlet weak var fourImageView: UIImageView!
    @IBOutlet weak var fiveImageView: UIImageView!
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBAction func tappedEvaluateButton(_ sender: UIButton) {
        if let user = Auth.auth().currentUser {
            if let evaluateVC = self.storyboard?.instantiateViewController(withIdentifier: "Evaluate") as? EvaluateViewController
            {
                evaluateVC.user = String(user.email!.split(separator: "@")[0])
                evaluateVC.whatEvaluate = "etc"
                evaluateVC.storeName = self.storeName
                evaluateVC.storeNum = self.storeNum
                evaluateVC.category = self.category
                self.navigationController?.pushViewController(evaluateVC, animated: true)
            }
        } else {
            if let logInVC = self.storyboard?.instantiateViewController(identifier: "LogIn") as? LogInViewController
            {
                logInVC.fromMypage = false
                logInVC.modalTransitionStyle = .coverVertical
                logInVC.modalPresentationStyle = .fullScreen
                self.present(logInVC, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        commentArray.removeAll()
        DispatchQueue.main.async {
            self.getCommentData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setMKMapView()
        registerXib()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendEtcData(num: String, name: String, category: String, address: String, grade: Double, count: Int, date: String, longitude: String, latitude: String) {
        self.storeNum = num
        self.storeName = name
        self.category = category
        self.grade = grade
        self.commentCount = count
        self.date = date
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
    }
    
    func setUI() {
        addressLabel.text = address
        commentButton.layer.cornerRadius = 4
        commentButton.layer.borderWidth = 1
        commentButton.layer.borderColor = UIColor.veryLightPinkTwo.cgColor
        commentCountLabel.text = "기타리뷰 \(commentCount)개"
        
        switch round(grade) {
        case 1:
            oneImageView.image = UIImage(named: "userEtc1.png")
        case 2:
            oneImageView.image = UIImage(named: "userEtc1.png")
            twoImageView.image = UIImage(named: "userEtc1.png")
        case 3:
            oneImageView.image = UIImage(named: "userEtc1.png")
            twoImageView.image = UIImage(named: "userEtc1.png")
            threeImageView.image = UIImage(named: "userEtc1.png")
        case 4:
            oneImageView.image = UIImage(named: "userEtc1.png")
            twoImageView.image = UIImage(named: "userEtc1.png")
            threeImageView.image = UIImage(named: "userEtc1.png")
            fourImageView.image = UIImage(named: "userEtc1.png")
        case 5:
            oneImageView.image = UIImage(named: "userEtc1.png")
            twoImageView.image = UIImage(named: "userEtc1.png")
            threeImageView.image = UIImage(named: "userEtc1.png")
            fourImageView.image = UIImage(named: "userEtc1.png")
            fiveImageView.image = UIImage(named: "userEtc1.png")
        default:
            return
        }
    }
    
    func getCommentData() {
        db.collection("store").document(storeNum).collection("sanitation").document("comment").getDocument()
        { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let querySnapshot = querySnapshot {
                    querySnapshot.data()?.forEach() { (key, value) in
                        self.commentArray.append(value)
                    }
                } else {
                    self.commentArray = []
                }
            }
        }
        commentTableView.delegate = self
        commentTableView.dataSource = self
    }
    

}

extension EtcViewController: UITableViewDataSource, UITableViewDelegate {
    private func registerXib() {
        let nibName = UINib(nibName: "CommentTableViewCell", bundle: nil)
        commentTableView.register(nibName, forCellReuseIdentifier: "CommentCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as!
            CommentTableViewCell
        let comment = commentArray[indexPath.row] as! Array<Any>
        
        cell.selectionStyle = .none
        cell.oneImageView.image = UIImage(named: "userEtc0.png")
        cell.twoImageView.image = UIImage(named: "userEtc0.png")
        cell.threeImageView.image = UIImage(named: "userEtc0.png")
        cell.fourImageView.image = UIImage(named: "userEtc0.png")
        cell.fiveImageView.image = UIImage(named: "userEtc0.png")
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width / 2
        cell.commentLabel.text = comment[0] as? String ?? "Error 404"
        cell.userLabel.text = comment[1] as? String ?? "Error 404"
        cell.dateLabel.text = comment[2] as? String ?? "어제"
        
        switch comment[3] as? Int {
        case 1:
            oneImageView.image = UIImage(named: "userEtc1.png")
        case 2:
            oneImageView.image = UIImage(named: "userEtc1.png")
            twoImageView.image = UIImage(named: "userEtc1.png")
        case 3:
            oneImageView.image = UIImage(named: "userEtc1.png")
            twoImageView.image = UIImage(named: "userEtc1.png")
            threeImageView.image = UIImage(named: "userEtc1.png")
        case 4:
            oneImageView.image = UIImage(named: "userEtc1.png")
            twoImageView.image = UIImage(named: "userEtc1.png")
            threeImageView.image = UIImage(named: "userEtc1.png")
            fourImageView.image = UIImage(named: "userEtc1.png")
        default:
            oneImageView.image = UIImage(named: "userEtc1.png")
            twoImageView.image = UIImage(named: "userEtc1.png")
            threeImageView.image = UIImage(named: "userEtc1.png")
            fourImageView.image = UIImage(named: "userEtc1.png")
            fiveImageView.image = UIImage(named: "userEtc1.png")
        }
        return cell
    }
}

extension EtcViewController: MKMapViewDelegate {
    func setMKMapView() {
        mapView.showsUserLocation = false
        mapView.setUserTrackingMode(.follow, animated: true)
        
        let coordinate = CLLocationCoordinate2D(latitude: (latitude as NSString).doubleValue, longitude: (longitude as NSString).doubleValue)
        let storeLocation = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(storeLocation, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
    }
}

extension EtcViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if category == "food" || category == "cafe" || category == "bar" {
            return IndicatorInfo(title: "맛")
        } else {
            return IndicatorInfo(title: "기타")
        }
    }
}
