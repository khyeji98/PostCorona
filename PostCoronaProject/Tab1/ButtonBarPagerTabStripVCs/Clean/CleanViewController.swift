//
//  HygieneViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/19.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class CleanViewController: UIViewController {

    var storeNum = String()
    var storeName = String()
    var category = String()
    var grade = Double()
    var commentCount = Int()
    var date = String()
    
    var foodSafety = Int()
    var cescoFood = Bool()
    var cescoMembers = Bool()
    var commentArray = [Any]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var noCertiLabel: UILabel!
    @IBOutlet weak var foodSafetyImageView: UIImageView!
    @IBOutlet weak var cescoFoodImageView: UIImageView!
    @IBOutlet weak var cescoMembersImageView: UIImageView!
    @IBOutlet weak var transitionView: UIView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var twoImageView: UIImageView!
    @IBOutlet weak var threeImageView: UIImageView!
    @IBOutlet weak var fourImageView: UIImageView!
    @IBOutlet weak var fiveImageView: UIImageView!
    @IBOutlet weak var commentTableView: UITableView!
    
    @IBOutlet var safetyAndFood: NSLayoutConstraint!
    @IBOutlet var foodAndMembers: NSLayoutConstraint!
    @IBOutlet var membersAndView: NSLayoutConstraint!
    
    @IBAction func tappedEvaluateButton(_ sender: UIButton) {
        if let user = Auth.auth().currentUser {
            if let evaluateVC = self.storyboard?.instantiateViewController(withIdentifier: "Evaluate") as? EvaluateViewController
            {
                evaluateVC.user = String(user.email!.split(separator: "@")[0])
                evaluateVC.whatEvaluate = "sanitation"
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
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getData()
        getCommentData()
        
        setLayout()
        registerXib()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendCleanData(num: String, name: String, category: String, grade: Double, count: Int, date: String) {
        self.storeNum = num
        self.storeName = name
        self.category = category
        self.grade = grade
        self.commentCount = count
        self.date = date
    }
    
    func setUI() {
        commentButton.layer.cornerRadius = 4
        commentButton.layer.borderWidth = 1
        commentButton.layer.borderColor = UIColor.veryLightPinkTwo.cgColor
        commentCountLabel.text = "위생리뷰 \(commentCount)개"
        
        switch round(grade) {
        case 1:
            oneImageView.image = UIImage(named: "userClean1.png")
        case 2:
            oneImageView.image = UIImage(named: "userClean1.png")
            twoImageView.image = UIImage(named: "userClean1.png")
        case 3:
            oneImageView.image = UIImage(named: "userClean1.png")
            twoImageView.image = UIImage(named: "userClean1.png")
            threeImageView.image = UIImage(named: "userClean1.png")
        case 4:
            oneImageView.image = UIImage(named: "userClean1.png")
            twoImageView.image = UIImage(named: "userClean1.png")
            threeImageView.image = UIImage(named: "userClean1.png")
            fourImageView.image = UIImage(named: "userClean1.png")
        case 5:
            oneImageView.image = UIImage(named: "userClean1.png")
            twoImageView.image = UIImage(named: "userClean1.png")
            threeImageView.image = UIImage(named: "userClean1.png")
            fourImageView.image = UIImage(named: "userClean1.png")
            fiveImageView.image = UIImage(named: "userClean1.png")
        default:
            return
        }
    }
    
    func getData() {
        DispatchQueue.global().async {
            self.db.collection("store").document(self.storeName).collection("sanitation").document("certification").getDocument()
            { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let querySnapshot = querySnapshot {
                        self.cescoFood = querySnapshot.get("cescoFood") as? Bool ?? false
                        self.cescoMembers = querySnapshot.get("cescoMembers") as? Bool ?? false
                        self.foodSafety = querySnapshot.get("foodSafety") as? Int ?? 0
                    }
                }
            }
        }
    }
    
    func setLayout() {
        if cescoFood == false, cescoMembers == false, foodSafety == 0 {
            cescoFoodImageView.isHidden = true
            cescoMembersImageView.isHidden = true
            foodSafetyImageView.isHidden = true
            noCertiLabel.isHidden = false
        } else {
            noCertiLabel.isHidden = true
            
            if foodSafety == 0 {
                foodSafetyImageView.isHidden = true
                safetyAndFood.constant = 0 - foodSafetyImageView.frame.height
            } else {
                switch foodSafety {
                case 1:
                    foodSafetyImageView.image = UIImage(named: "excellent.png")
                case 2:
                    foodSafetyImageView.image = UIImage(named: "verygood.png")
                case 3:
                    foodSafetyImageView.image = UIImage(named: "good.png")
                default:
                    return
                }
            }
            if cescoFood == false {
                cescoFoodImageView.isHidden = true
                foodAndMembers.constant = 0 - cescoFoodImageView.frame.height
            }
            if cescoMembers == false {
                cescoMembersImageView.isHidden = true
                membersAndView.constant = 0 - cescoMembersImageView.frame.height
            }
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

extension CleanViewController: UITableViewDataSource {
    private func registerXib() {
        let nibName = UINib(nibName: "CommentTableViewCell", bundle: nil)
        commentTableView.register(nibName, forCellReuseIdentifier: "CommentCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as!
            CommentTableViewCell
        let comment = commentArray[indexPath.row] as! Array<Any>
        
        cell.selectionStyle = .none
        cell.oneImageView.image = UIImage(named: "userClean0.png")
        cell.twoImageView.image = UIImage(named: "userClean0.png")
        cell.threeImageView.image = UIImage(named: "userClean0.png")
        cell.fourImageView.image = UIImage(named: "userClean0.png")
        cell.fiveImageView.image = UIImage(named: "userClean0.png")
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width / 2
        cell.commentLabel.text = comment[0] as? String ?? "Error 404"
        cell.userLabel.text = comment[1] as? String ?? "Error 404"
        cell.dateLabel.text = comment[2] as? String ?? "어제"
        
        switch comment[3] as? Int {
        case 1:
            oneImageView.image = UIImage(named: "userClean1.png")
        case 2:
            oneImageView.image = UIImage(named: "userClean1.png")
            twoImageView.image = UIImage(named: "userClean1.png")
        case 3:
            oneImageView.image = UIImage(named: "userClean1.png")
            twoImageView.image = UIImage(named: "userClean1.png")
            threeImageView.image = UIImage(named: "userClean1.png")
        case 4:
            oneImageView.image = UIImage(named: "userClean1.png")
            twoImageView.image = UIImage(named: "userClean1.png")
            threeImageView.image = UIImage(named: "userClean1.png")
            fourImageView.image = UIImage(named: "userClean1.png")
        default:
            oneImageView.image = UIImage(named: "userClean1.png")
            twoImageView.image = UIImage(named: "userClean1.png")
            threeImageView.image = UIImage(named: "userClean1.png")
            fourImageView.image = UIImage(named: "userClean1.png")
            fiveImageView.image = UIImage(named: "userClean1.png")
        }
        return cell
    }
    
    
}

extension CleanViewController: UITableViewDelegate {
    
}

extension CleanViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "위생")
    }
}
