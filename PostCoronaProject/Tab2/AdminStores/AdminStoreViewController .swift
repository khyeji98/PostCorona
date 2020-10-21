//
//  AdminStoreViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/25.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class AdminStoreViewController: UIViewController {

    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addStoreButton: UIButton!
    @IBOutlet weak var myStoreTableView: UITableView!
    
    let db: Firestore! = Firestore.firestore()
    var myStoreArray = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myStoreTableView.delegate = self
        self.myStoreTableView.dataSource = self
        loadMyData()
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
        if let addStoreVC = self.storyboard?.instantiateViewController(withIdentifier: "AddStore") {
            self.navigationController?.pushViewController(addStoreVC, animated: true)
        }
    }
}

extension AdminStoreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myStoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myStoreList", for: indexPath) as! AdminStoreListTableViewCell
        let myStore = myStoreArray[indexPath.row]
        
        cell.storeNameLabel.text = myStore.storeName
        cell.storeAddrLabel.text = "\(myStore.add1) \(myStore.add2) \(myStore.add3)"
        cell.safeCountingLabel.text = "안심 스티커 \(myStore.relief)개"
        cell.category = myStore.category
        
        return cell
    }
}

extension AdminStoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "수정", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            if let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditStore") as? EditStoreViewController {
                self.navigationController?.pushViewController(editVC, animated: true)
            }
        })
        
        let delete = UIContextualAction(style: .destructive, title: "삭제", handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let alertController = UIAlertController(title: nil, message: "해당 업장을 영구삭제하시겠습니까?", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "네, 삭제하겠습니다.", style: .default, handler: { _ in
                self.db.collection("storeList").document(self.myStoreArray[indexPath.row].storeName).delete() { error in
                    if let error = error {
                        print(error)
                    }
                }
            })
            let noPressed = UIAlertAction(title: "아니오.", style: .default, handler: { _ in
                
            })
            alertController.addAction(yesPressed)
            alertController.addAction(noPressed)
            self.present(alertController, animated: true)
        })
        
        edit.backgroundColor = .deepSkyBlue
        delete.backgroundColor = .dustyOrange
        
        let configuration = UISwipeActionsConfiguration(actions: [edit, delete])
        
        return configuration
    }
}
