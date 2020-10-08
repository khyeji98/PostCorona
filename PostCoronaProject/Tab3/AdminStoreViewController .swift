//
//  AdminStoreViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/25.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class AdminStoreViewController: UIViewController {

    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addStoreButton: UIButton!
    @IBOutlet weak var myStoreTableView: UITableView!
    
    let db: Firestore! = Firestore.firestore()
    var myStoreArray = [Store]()
    var myStoreImageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.myStoreTableView.delegate = self
        self.myStoreTableView.dataSource = self
        loadMyData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.myStoreArray.removeAll()
        self.myStoreImageArray.removeAll()
    }
    
    func loadMyData() {
        let collectionRef = db.collection("storeList")
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        collectionRef.whereField("uid", isEqualTo: userId).getDocuments() { (querySnapshot, error) in
            if let error = error {
                self.myStoreTableView.isHidden = true
                print(error.localizedDescription)
            } else {
                self.myStoreTableView.isHidden = false
                if let query = querySnapshot {
                    self.myStoreArray = query.documents.compactMap({Store(dictionary: $0.data())})
                    DispatchQueue.main.async {
                        self.myStoreTableView.reloadData()
                    }
                } else {
                    self.myStoreTableView.isHidden = true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedAddButton(_ sender: UIButton) {
        if let addStoreVC = self.storyboard?.instantiateViewController(withIdentifier: "addStore") {
            self.navigationController?.pushViewController(addStoreVC, animated: true)
        }
    }
}

extension AdminStoreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myStoreList", for: indexPath) as! MyStoreListTableViewCell
        let myStore = myStoreArray[indexPath.row]
        
        DispatchQueue.main.async {
            self.db.collection("checkList\(myStore.category.capitalized)").document(myStore.storeNum).addSnapshotListener() { (querySnapshot, error) in
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
                            cell.todayCheckImageView.image = UIImage(named: "cleanCheckActive.png")
                        } else {
                            cell.todayCheckImageView.image = UIImage(named: "cleanCheck.png")
                        }
                    }
                } else {
                    cell.todayCheckImageView.image = UIImage(named: "cleanCheck.png")
                }
            }
        }
        
        cell.storeNameLabel.text = myStore.storeName
        cell.storeAddrLabel.text = "\(myStore.add1) \(myStore.add2) \(myStore.add3)"
        cell.safeCountingLabel.text = "안심 스티커 \(myStore.relief)개"
        cell.category = myStore.category
        
        cell.storeImageView.image = UIImage(named: "default.png")
        
        Storage.storage().reference(forURL: "gs://together-at001.appspot.com/\(myStore.storeNum).png").downloadURL(completion: { (url, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let url = url {
                    cell.storeImageView.sd_setImage(with: url)
                }
            }
        })
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension AdminStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: nil, handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            
            let selected = self.myStoreArray[indexPath.row]
            
            if let editStoreVC = self.storyboard?.instantiateViewController(withIdentifier: "editStore") as? EditStoreViewController {
                editStoreVC.myStore = selected
                self.navigationController?.pushViewController(editStoreVC, animated: true)
            }
        })
        
        let delete = UIContextualAction(style: .destructive, title: nil, handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let alertController = UIAlertController(title: nil, message: "해당 업장을 영구삭제하시겠습니까?", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "네, 삭제하겠습니다.", style: .default, handler: { _ in
                self.db.collection("storeList").document(self.myStoreArray[indexPath.row].storeNum).delete() { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        self.myStoreTableView.deleteRows(at: [indexPath], with: .automatic)
                        self.myStoreArray.remove(at: indexPath.row)
                        self.myStoreTableView.reloadData()
                    }
                }
                // storage 사진 삭제
            })
            let noPressed = UIAlertAction(title: "아니오.", style: .default)
            
            alertController.addAction(yesPressed)
            alertController.addAction(noPressed)
            self.present(alertController, animated: true, completion: nil)
        })
        
        edit.backgroundColor = .deepSkyBlue
        delete.backgroundColor = .dustyOrange
        
        edit.image = UIImage(named: "edit.png")
        delete.image = UIImage(named: "delete.png")
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = self.myStoreArray[indexPath.row]
        
        if let todayCheckListVC = self.storyboard?.instantiateViewController(withIdentifier: "todayCheckList") as? TodayCheckListViewController {
            
            todayCheckListVC.category = selected.category
            todayCheckListVC.storeName = selected.storeName
            todayCheckListVC.storeNum = selected.storeNum
            
            self.navigationController?.pushViewController(todayCheckListVC, animated: true)
        }
    }
}
