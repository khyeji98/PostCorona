//
//  ReportListViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/26.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class ReportListViewController: UIViewController {

    var storeNum = String()
    var timeDelayed = String()
    var todayReportArray: [Any] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var reportListTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        todayReportArray.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportListTableView.dataSource = self
        reportListTableView.delegate = self
        checkTodayData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkTodayData() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let todayDate = formatter.string(from: Date())
        
        db.collection("store").document(storeNum).collection("covid19").document("report").getDocument
        { (querySnapshot,error) in
            if let querySnapshot = querySnapshot {
                if let data = querySnapshot.data() {
                    self.todayReportArray = data.map{$0.value}
                    self.noDataLabel.isHidden = true
                    DispatchQueue.main.async {
                        self.reportListTableView.reloadData()
                    }
                }else {
                    self.reportListTableView.isHidden = true
                    self.noDataLabel.isHidden = false
                }
            }
        }
    }

    
    func calculateTime(_ sender: String) {
        let timeFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowTime = timeFormatter.string(from: Date())
        let todayDate = dateFormatter.string(from: Date())
        
        if todayDate == sender.split(separator: " ")[0] {
            self.timeDelayed = "\(sender.split(separator: " ")[0])"
        } else {
            guard let reportTime = timeFormatter.date(from: sender) else { return }
            guard let thisTime = timeFormatter.date(from: nowTime) else { return }
            
            self.timeDelayed = "\(Int(thisTime.timeIntervalSince(reportTime)/60))분전"
        }   
    }
}

extension ReportListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayReportArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportListCell", for: indexPath) as! ReportListTableViewCell
        let report = todayReportArray[indexPath.row] as! [Any]
        
        switch report[2] as! Int {
        case 0:
            cell.reportImageView.image = UIImage(named: "reportMask.png")
            cell.reportTopicLabel.text = "마스크 미착용"
        case 1:
            cell.reportImageView.image = UIImage(named: "reportList.png")
            cell.reportTopicLabel.text = "명부 미작성"
        case 2:
            cell.reportImageView.image = UIImage(named: "reportHandSanitizer.png")
            cell.reportTopicLabel.text = "손소독제 미비치"
        case 3:
            cell.reportImageView.image = UIImage(named: "reportEtc.png")
            cell.reportTopicLabel.text = "기타 사항"
        default:
            cell.reportImageView.image = UIImage(named: "reportEtc.png")
            cell.reportTopicLabel.text = "알수없음"
        }
        
        cell.reportCommentLabel.text = report[0] as? String
        
        calculateTime(report[1] as! String)
        cell.reportTimeLabel.text = self.timeDelayed
        
        return cell
    }
    
    
}
