//
//  StoreCheckListViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/20.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class DisinListViewController: UIViewController {

    var category = String()
    var storeName = String()
    var listArray = [String]()
    var resultArray = [Bool]()
    let db = Firestore.firestore()
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listArray.removeAll()
        resultArray.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setData() {
        db.collection("\(category)List").document("daily").getDocument() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                querySnapshot!.data()!.forEach() { (key, value) in
                    self.listArray.append(value as! String)
                }
            }
        }
        db.collection("foodList").document("once").getDocument() { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                querySnapshot!.data()!.forEach() { (key, value) in
                    self.listArray.append(value as! String)
                }
            }
        }
        
    }
}

extension DisinListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisinListCell", for: indexPath) as! DisinListTableViewCell
        let list = listArray[indexPath.row]
        
        cell.selectionStyle = .none
        cell.numLabel.text = "\(indexPath.row)."
        cell.listLabel.text = list
        
        if resultArray[indexPath.row] == true {
            cell.checkImageView.image = UIImage(named: "cleanCheckActive.png")
        } else {
            cell.checkImageView.image = UIImage(named: "cleanCheck.png")
        }
        
        return cell
    }


}

extension DisinListViewController: UITableViewDelegate {

}
