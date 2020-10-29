//
//  DisinfectionViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/19.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class DisinfectionViewController: UIViewController {

    var storeNum = String()
    var storeName = String()
    var category = String()
    var grade = Double()
    var commentCount = Int()
    var date = String()
    
    var commentArray = [Any]()
    var dailyArray = [Bool]()
    var onceArray: [Bool]?
    var todayCheck = Bool()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var handSanitizerImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var disinfectionImageView: UIImageView!
    @IBOutlet weak var icOneImageView: UIImageView!
    @IBOutlet weak var icTwoImageView: UIImageView!
    @IBOutlet weak var icThreeImageView: UIImageView!
    @IBOutlet weak var icFourImgaeView: UIImageView!
    @IBOutlet var leftAndOne: NSLayoutConstraint!
    @IBOutlet var threeAndFour: NSLayoutConstraint!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var twoImageView: UIImageView!
    @IBOutlet weak var threeImageView: UIImageView!
    @IBOutlet weak var fourImageView: UIImageView!
    @IBOutlet weak var fiveImageView: UIImageView!
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBAction func tappedMoreButton(_ sender: UIButton) {
        guard let once = onceArray else { return }
        if let disinListVC = self.storyboard?.instantiateViewController(withIdentifier: "DisinList") as? DisinListViewController
        {
            disinListVC.category = category
            disinListVC.storeName = storeName
            
            if self.todayCheck == true {
                disinListVC.resultArray = self.dailyArray + once
            } else {
                if category == "karaoke" {
                    self.dailyArray = [false, false, false, false, false]
                    disinListVC.resultArray = self.dailyArray + once
                } else {
                    self.dailyArray = [false, false, false, false]
                    disinListVC.resultArray = self.dailyArray + once
                }
            }
            self.navigationController?.pushViewController(disinListVC, animated: true)
        }
    }
    
    @IBAction func tappedReportButton(_ sender: UIButton) {
        if let user = Auth.auth().currentUser {
            if let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "Report") as? ReportViewController
            {
                reportVC.user = String(user.email!.split(separator: "@")[0])
                reportVC.storeNum = self.storeNum
                self.navigationController?.pushViewController(reportVC, animated: true)
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
    
    @IBAction func tappedEvaluateButton(_ sender: UIButton) {
        if let user = Auth.auth().currentUser {
            if let evaluateVC = self.storyboard?.instantiateViewController(withIdentifier: "Evaluate") as? EvaluateViewController
            {
                evaluateVC.user = String(user.email!.split(separator: "@")[0])
                evaluateVC.whatEvaluate = "covid19"
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
        dailyArray.removeAll()
        onceArray?.removeAll()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        registerXib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendDisinData(num: String, name: String, category: String, grade: Double, count: Int, date: String) {
        self.storeNum = num
        self.storeName = name
        self.category = category
        self.grade = grade
        self.commentCount = count
        self.date = date
        
        switch category {
        case "food", "cafe", "bar":
            oneImageView.image = UIImage(named: "2M.png")
            twoImageView.image = UIImage(named: "wrapping.png")
            threeImageView.image = UIImage(named: "kiosk.png")
            fourImageView.image = UIImage(named: "reservation.png")
        case "pc":
            oneImageView.image = UIImage(named: "2M.png")
            twoImageView.image = UIImage(named: "education.png")
            threeImageView.image = UIImage(named: "list.png")
            icFourImgaeView.isHidden = true
            leftAndOne.constant = (leftAndOne.constant * 2) + icFourImgaeView.frame.width
            threeAndFour.constant = 0 - icFourImgaeView.frame.width
        case "karaoke":
            oneImageView.image = UIImage(named: "mic.png")
            twoImageView.image = UIImage(named: "2M.png")
            threeImageView.image = UIImage(named: "education.png")
            icFourImgaeView.isHidden = true
            leftAndOne.constant = (leftAndOne.constant * 2) + icFourImgaeView.frame.width
            threeAndFour.constant = 0 - icFourImgaeView.frame.width
        default:
            return
        }
        setUI()
        
            self.getData()
            self.getCommentData()
        
    }
    
    func setUI() {
        commentButton.layer.cornerRadius = 4
        commentButton.layer.borderWidth = 1
        commentButton.layer.borderColor = UIColor.veryLightPinkTwo.cgColor
        commentCountLabel.text = "방역리뷰 \(commentCount)개"
        
        if self.commentArray.count != 0 {
            switch round(grade) {
            case 1:
                oneImageView.image = UIImage(named: "userPrevention1.png")
            case 2:
                oneImageView.image = UIImage(named: "userPrevention1.png")
                twoImageView.image = UIImage(named: "userPrevention1.png")
            case 3:
                oneImageView.image = UIImage(named: "userPrevention1.png")
                twoImageView.image = UIImage(named: "userPrevention1.png")
                threeImageView.image = UIImage(named: "userPrevention1.png")
            case 4:
                oneImageView.image = UIImage(named: "userPrevention1.png")
                twoImageView.image = UIImage(named: "userPrevention1.png")
                threeImageView.image = UIImage(named: "userPrevention1.png")
                fourImageView.image = UIImage(named: "userPrevention1.png")
            case 5:
                oneImageView.image = UIImage(named: "userPrevention1.png")
                twoImageView.image = UIImage(named: "userPrevention1.png")
                threeImageView.image = UIImage(named: "userPrevention1.png")
                fourImageView.image = UIImage(named: "userPrevention1.png")
                fiveImageView.image = UIImage(named: "userPrevention1.png")
            default:
                return
            }
        }
    }
    
    func getData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.string(from: Date())
        
        db.collection("store").document(storeNum).collection("covid19").document("check").getDocument
        { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let querySnapshot = querySnapshot {
                    if self.date == todayDate {
                            guard let daily = querySnapshot.get("daily") as? [Bool] else { return }
                            self.dailyArray = daily
                            self.todayCheck = true
                        } else {
                            self.todayCheck = false
                        }
                    
                    guard let once = querySnapshot.get("once") as? [Bool] else { return }
                    self.onceArray = once
                }
            }
        }
        showData()
    }
    
    func showData() {
        guard let once = onceArray else { return }
        print(once)
        
        if !dailyArray.isEmpty {
            if dailyArray[0] == true {
                maskImageView.image = UIImage(named: "maskActive.png")
            }
            if dailyArray[1] == true {
                handSanitizerImageView.image = UIImage(named: "handSanitizerActive.png")
            }
            if dailyArray[2] == true {
                listImageView.image = UIImage(named: "listActive.png")
            }
            if dailyArray[3] == true {
                disinfectionImageView.image = UIImage(named: "disinfectionActive.png")
            }
        }
        
        switch category {
        case "food", "cafe", "bar":
            if once[0] == true {
                icOneImageView.image = UIImage(named: "2MActive.png")
            } else {
                icOneImageView.image = UIImage(named: "2M.png")
            }
            if once[1] == true {
                icTwoImageView.image = UIImage(named: "wrappingActive.png")
            } else {
                icTwoImageView.image = UIImage(named: "wrapping.png")
            }
            if once[2] == true {
                icThreeImageView.image = UIImage(named: "kioskActive.png")
            } else {
                icThreeImageView.image = UIImage(named: "kiosk.png")
            }
            if once[3] == true {
                icFourImgaeView.image = UIImage(named: "reservationActive.png")
            } else {
                icFourImgaeView.image = UIImage(named: "reservation.png")
            }
        case "pc":
            if once[0] == true {
                icOneImageView.image = UIImage(named: "2MActive.png")
            } else {
                icOneImageView.image = UIImage(named: "2M.png")
            }
            if once[1] == true {
                icTwoImageView.image = UIImage(named: "educationActive.png")
            } else {
                icTwoImageView.image = UIImage(named: "education.png")
            }
            if once[2] == true {
                icThreeImageView.image = UIImage(named: "listActive.png")
            } else {
                icThreeImageView.image = UIImage(named: "list.png")
            }
        case "karaoke":
            if dailyArray[4] == true {
                icOneImageView.image = UIImage(named: "micActive.png")
            } else {
                icOneImageView.image = UIImage(named: "mic.png")
            }
            if once[0] == true {
                icTwoImageView.image = UIImage(named: "2MActive.png")
            } else {
                icTwoImageView.image = UIImage(named: "2M.png")
            }
            if once[1] == true {
                icThreeImageView.image = UIImage(named: "educationActive.png")
            } else {
                icThreeImageView.image = UIImage(named: "education.png")
            }
        default:
            return
        }
    }
    
    func getCommentData() {
        db.collection("store").document(storeNum).collection("covid19").document("comment").getDocument()
        { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let querySnapshot = querySnapshot {
                    querySnapshot.data()?.forEach() { (key, value) in
                        self.commentArray.append(value)
                        DispatchQueue.main.async {
                            self.commentTableView.reloadData()
                        }
                    }
                } else {
                    self.commentArray = []
                }
            }
        }
        
    }
    
    
}

extension DisinfectionViewController: UITableViewDataSource, UITableViewDelegate {
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
        cell.oneImageView.image = UIImage(named: "userPrevention0.png")
        cell.twoImageView.image = UIImage(named: "userPrevention0.png")
        cell.threeImageView.image = UIImage(named: "userPrevention0.png")
        cell.fourImageView.image = UIImage(named: "userPrevention0.png")
        cell.fiveImageView.image = UIImage(named: "userPrevention0.png")
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width / 2
        cell.commentLabel.text = comment[0] as? String ?? "Error 404"
        cell.userLabel.text = comment[1] as? String ?? "Error 404"
        cell.dateLabel.text = comment[2] as? String ?? "어제"
        
        switch comment[3] as? Int {
        case 1:
            oneImageView.image = UIImage(named: "userPrevention1.png")
        case 2:
            oneImageView.image = UIImage(named: "userPrevention1.png")
            twoImageView.image = UIImage(named: "userPrevention1.png")
        case 3:
            oneImageView.image = UIImage(named: "userPrevention1.png")
            twoImageView.image = UIImage(named: "userPrevention1.png")
            threeImageView.image = UIImage(named: "userPrevention1.png")
        case 4:
            oneImageView.image = UIImage(named: "userPrevention1.png")
            twoImageView.image = UIImage(named: "userPrevention1.png")
            threeImageView.image = UIImage(named: "userPrevention1.png")
            fourImageView.image = UIImage(named: "userPrevention1.png")
        default:
            oneImageView.image = UIImage(named: "userPrevention1.png")
            twoImageView.image = UIImage(named: "userPrevention1.png")
            threeImageView.image = UIImage(named: "userPrevention1.png")
            fourImageView.image = UIImage(named: "userPrevention1.png")
            fiveImageView.image = UIImage(named: "userPrevention1.png")
        }
        return cell
    }
}

extension DisinfectionViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "방역")
    }
}
