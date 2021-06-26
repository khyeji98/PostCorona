//
//  TodayCheckListViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/28.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class CheckListViewController: UIViewController {

    var whatData = Int()
    var edit = Bool()
    var storeNum = String()
    var category = String()
    var listArray = [Any]()
    var resultArray = [Any]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var checkListTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listArray.removeAll()
        resultArray.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTodayState()
        checkListTableView.delegate = self
        checkListTableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        if whatData == 0 {
            if listArray.count == resultArray.count {
                DispatchQueue.global().async {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let todayDate = formatter.string(from: Date())
                    
                    self.db.collection("store").document(self.storeNum).collection("covid19").document("check").setData(["daily":self.resultArray], merge: true)
                    self.db.collection("store").document(self.storeNum).setData(["date": todayDate], merge: true)
                }
            }
        } else {
            if listArray.count == resultArray.count {
                db.collection("store").document(storeNum).collection("covid19").document("check").setData(["once":resultArray], merge: true)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedCheckButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        resultArray[sender.tag] = sender.isSelected
    }
    
    func checkTodayState() {
        // daily
        if whatData == 0 {
            mainLabel.text = "체크리스트 관리"
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd"
//            let todayDate = formatter.string(from: Date())
            
            db.collection("\(category)List").document("daily").getDocument() { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.listArray = querySnapshot.get("daily") as! [Any]
                }}
            db.collection("store").document(storeNum).collection("covid19").document("check").getDocument()
            { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.resultArray = querySnapshot.get("daily") as! [Any]
//                    print(self.resultArray)
                    DispatchQueue.main.async {
                        self.checkListTableView.reloadData()
                    }
                } else {
                    self.resultArray = Array(repeating: false, count: self.listArray.count)
                    DispatchQueue.main.async {
                        self.checkListTableView.reloadData()
                    }
                }
            }
            
            // onece
        } else if whatData == 1 {
            mainLabel.text = "필수 점검 항목"
            
            db.collection("\(category)List").document("once").getDocument() {(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    querySnapshot.data()?.forEach({ (key, value) in self.listArray.append(value as! String)})
                }
            }
            if edit == true {
                db.collection("store").document(storeNum).collection("covid19").document("check").getDocument
                { (querySnapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.resultArray = querySnapshot!.get("once") as! [Bool]
                        DispatchQueue.main.async {
                            self.checkListTableView.reloadData()
                        }
                    }
                }
            } else {
                self.resultArray = Array(repeating: false, count: self.listArray.count)
                DispatchQueue.main.async {
                    self.checkListTableView.reloadData()
                }
            }
        }
    }
}

extension CheckListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListCell", for: indexPath) as! CheckListTableViewCell
        let list = listArray[indexPath.row]
        let result = resultArray[indexPath.row]
        
        cell.checkButton.tag = indexPath.row
        cell.numLabel.text = "\(indexPath.row + 1)."
        cell.dailyListLabel.text = list as? String
        cell.checkButton.isSelected = result as! Bool
        cell.selectionStyle = .none
        
        return cell
    }
}

extension CheckListViewController: UITableViewDelegate {
    
}
