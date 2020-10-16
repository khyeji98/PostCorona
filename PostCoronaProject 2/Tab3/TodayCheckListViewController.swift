//
//  TodayCheckListViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/28.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class TodayCheckListViewController: UIViewController {

    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var checkListTableView: UITableView!
    
    let db: Firestore! = Firestore.firestore()
    var checkListArray = [String]()
    var checkListResultArray = [Bool]()
    
    var category: String?
    var storeName: String?
    var storeNum: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.checkListTableView.dataSource = self
        self.checkListTableView.delegate = self
        self.checkListTableView.allowsSelection = false
        
        loadCheckListData()

        if let storeName = storeName {
            self.storeNameLabel.text = storeName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.checkListArray.removeAll()
        self.checkListResultArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
//        DispatchQueue.global().async {
//            guard let category = self.category else { return }
//            guard let storeNum = self.storeNum else { return }
//            let collectionRef = self.db.collection("checkList\(category.capitalized)")
//
//            collectionRef.document(storeNum).setData(["todayCheck":self.checkListResultArray], merge: true) { error in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//            }
//            collectionRef.document(storeNum).setData(["date":Timestamp(date: Date())], merge: true)
//        }
        print(checkListResultArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedCheckButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

    }
    
    func loadCheckListData() {
        let collectionRef = db.collection("checkList")
        guard let category = self.category else { return }
        
        collectionRef.document("store").getDocument() { (querySnapshot, error) in
            if let error = error {
                print("에러남: \(error.localizedDescription)")
            } else {
                if let querySnapshot = querySnapshot {
                    self.checkListArray = querySnapshot[category] as? [String] ?? [""]
                    self.checkListResultArray = Array(repeating: false, count: self.checkListArray.count)
                    
                    DispatchQueue.main.async {
                        self.checkListTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension TodayCheckListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.checkListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCheckListCell", for: indexPath) as! TodayCheckListTableViewCell
        let checkList = self.checkListArray[indexPath.row]
        
        cell.checkListNumLabel.text = "\(indexPath.row + 1)."
        cell.checkListDetailLabel.isHidden = true
        
        //* constraints 반응 느림
        if checkList.contains("/n") {
            cell.checkListDetailLabel.isHidden = false
            cell.checkListLabel.text = checkList.components(separatedBy: "/n")[0]
            cell.checkListDetailLabel.text = checkList.components(separatedBy: "/n")[1]
            cell.detailLabelAndBottomHeight.constant = 20
        } else {
            cell.checkListDetailLabel.isHidden = true
            cell.detailLabelAndBottomHeight.constant = 20 - cell.checkListDetailLabel.frame.height
            cell.checkListDetailLabel.text = nil
            cell.checkListLabel.text = checkList
        }
        
        cell.checkButton.tag = indexPath.row
        
//        cell.checkButton.addTarget(self, action: #selector(pressedButton(_:)), for: .touchUpInside)
        
        return cell
    }
    
//    @objc func pressedButton(_ sender: UIButton) {
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//        checkListResultArray[sender.tag] = !checkListResultArray[sender.tag]
//        sender.isSelected = !sender.isSelected
//        checkListTableView.beginUpdates()
//        checkListTableView.reloadRows(at: [indexPath], with: .none)
//        checkListTableView.endUpdates()
//    }
    
}

extension TodayCheckListViewController: UITableViewDelegate {


}
