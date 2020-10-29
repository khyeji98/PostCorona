//
//  AdminStoreViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/25.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class AdminViewController: UIViewController {

    let db = Firestore.firestore()
    var myStoreArray: [Store] = []
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var addStoreButton: UIButton!
    @IBOutlet weak var myStoreTableView: UITableView!
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedAddButton(_ sender: UIButton) {
        if let addStoreVC = self.storyboard?.instantiateViewController(withIdentifier: "AddStore") as? AddStoreViewController
        {
            addStoreVC.edit = false
            self.navigationController?.pushViewController(addStoreVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myStoreTableView.delegate = self
        self.myStoreTableView.dataSource = self
        loadMyData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        myStoreArray.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadMyData() {
        guard let userId = Auth.auth().currentUser?.email else { return }
        
        db.collection("store").whereField("email", isEqualTo: userId).getDocuments() { (querySnapshot, error) in
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
    
}

extension AdminViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myStoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminCell", for: indexPath) as! AdminTableViewCell
        
        let myStore = myStoreArray[indexPath.row]
        
        cell.storeNameLabel.text = myStore.storeName
        cell.storeAddrLabel.text = "\(myStore.add1) \(myStore.add2) \(myStore.add3)"
        
        Storage.storage().reference(forURL: "gs://together-at001.appspot.com/\(myStore.storeNum).png").downloadURL(completion: { (url, error) in
            if let url = url {
                cell.storeImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default.png"))
            }
        })
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.string(from: Date())
        
        if myStore.date == todayDate {
            cell.todayCheckImageView.image = UIImage(named: "checklistActive.png")
        }
        if myStore.date == todayDate {
            cell.todayReportImageView.image = UIImage(named: "reportActive.png")
        }
        
        return cell
    }
}

extension AdminViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let myStoreVC = self.storyboard?.instantiateViewController(withIdentifier: "MyStore") as? MyStoreViewController {
            myStoreVC.storeName = self.myStoreArray[indexPath.row].storeName
            myStoreVC.storeNum = self.myStoreArray[indexPath.row].storeNum
            myStoreVC.category = self.myStoreArray[indexPath.row].category
            self.navigationController?.pushViewController(myStoreVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: nil, handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            if let editVC = self.storyboard?.instantiateViewController(withIdentifier: "AddStore") as? AddStoreViewController {
                editVC.edit = true
                editVC.store = self.myStoreArray[indexPath.row]
                self.navigationController?.pushViewController(editVC, animated: true)
            }
        })
        
        let delete = UIContextualAction(style: .destructive, title: nil, handler: { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let alertController = UIAlertController(title: nil, message: "해당 업장을 영구삭제하시겠습니까?", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "네, 삭제하겠습니다.", style: .default, handler: { _ in
                self.db.collection("store").document(self.myStoreArray[indexPath.row].storeNum).delete() { error in
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
        
        let config = UISwipeActionsConfiguration(actions: [edit, delete])
        config.performsFirstActionWithFullSwipe = false
        
        edit.image = UIImage(named: "edit.png")
        delete.image = UIImage(named: "delete.png")
        
        edit.backgroundColor = .deepSkyBlue
        delete.backgroundColor = .dustyOrange
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return configuration
    }
}
