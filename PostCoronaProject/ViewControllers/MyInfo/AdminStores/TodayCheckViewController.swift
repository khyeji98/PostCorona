//
//  TodayCheckListViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/28.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class CheckViewController: UIViewController {

    var whatData = Int()
    var todayDate = String()
    var category = String()
    var storeName = String()
    var storeNum = String()
    var listArray = [Any]()
    var resultArray = [Bool]()
    var resultDictionary = [String:Bool]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var checkListTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        storeNameLabel.text = storeName
        checkTodayState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        listArray.removeAll()
        resultArray.removeAll()
        resultDictionary.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        //.collection("covid19").document("checklistDaily")
        if listArray.count == resultArray.count {
            db.collection("store").document(storeNum).setData(
                ["daily":resultArray], merge: true)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func tappedCheckButton(_ sender: UIButton) {
        resultArray[sender.tag] = sender.isSelected
    }
    
    func checkTodayState() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        todayDate = formatter.string(from: Date())
        
        db.collection("\(category)List").document("daily").getDocument { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let data = querySnapshot!.data() else { return }
                self.listArray = Array(data.values)
            }
        }
        //.collection("covid19").document("checklistDaily")
        db.collection("store").document(storeNum).getDocument
        { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let querySnapshot = querySnapshot {
                    if querySnapshot.get("date") as! String == self.todayDate {
//                        self.resultArray = Array(querySnapshot.data()!.values)
                        self.resultArray = querySnapshot.get("daily") as! [Bool]
                    } else {
                        self.resultArray = Array(repeating: false, count: self.listArray.count)
                    }
                } else {
                    self.resultArray = Array(repeating: false, count: self.listArray.count)
                }
            }
        }
    }

}

extension CheckViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCheckCell", for: indexPath) as! TodayCheckTableViewCell
        let list = listArray[indexPath.row] as! String
        
        cell.checkButton.tag = indexPath.row
        cell.numLabel.text = "\(indexPath.row + 1)."
        cell.dailyListLabel.text = list
        cell.checkButton.isSelected = !cell.checkButton.isSelected
        cell.checkButton.isSelected = resultArray[cell.checkButton.tag]
        cell.selectionStyle = .none
        
    }
    
}

extension CheckViewController: UITableViewDelegate {
    
}
