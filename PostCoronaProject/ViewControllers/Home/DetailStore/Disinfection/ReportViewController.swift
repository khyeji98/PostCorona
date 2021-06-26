//
//  ReportViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/24.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class ReportViewController: UIViewController {

    var storeNum = String()
    var user = String()
    var selectedTag: Int?
    let db = Firestore.firestore()
    
    @IBOutlet weak var handSanitizerButton: UIButton!
    @IBOutlet weak var maskButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    @IBOutlet weak var reportTextView: UITextView!
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        guard let reportComment = reportTextView.text else { return }
        guard let tag = selectedTag else { return }
        
        if reportComment == "정확한 신고는 더 좋은 가게를 만듭니다" || selectedTag == nil {
            let alertController = UIAlertController(title: nil, message: "신고 작성이 완료되지 않았습니다.", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(yesPressed)
            self.present(alertController, animated: true, completion: nil)
        } else {
            DispatchQueue.global().async {
                let dateFormatter = DateFormatter()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayDate = dateFormatter.string(from: Date())
                let nowTime = timeFormatter.string(from: Date())
                
                self.db.collection("store").document(self.storeNum).collection("covie19").document("report").setData(["\(self.user), \(todayDate)":[reportComment, nowTime, tag]])
                
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholderSetting()
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func setUI() {
        reportTextView.layer.cornerRadius = 4
        reportTextView.textContainerInset = UIEdgeInsets(top: 13, left: 12, bottom: 13, right: 12)
        
        maskButton.tag = 0
        listButton.tag = 1
        handSanitizerButton.tag = 2
        etcButton.tag = 3
        
        handSanitizerButton.addTarget(self, action: #selector(tappedReportIcon(_:)), for: .touchUpInside)
        maskButton.addTarget(self, action: #selector(tappedReportIcon(_:)), for: .touchUpInside)
        listButton.addTarget(self, action: #selector(tappedReportIcon(_:)), for: .touchUpInside)
        etcButton.addTarget(self, action: #selector(tappedReportIcon(_:)), for: .touchUpInside)
    }
    
    @objc func tappedReportIcon(_ sender: UIButton) {
        selectedTag = sender.tag
        switch sender {
        case maskButton:
            maskButton.isSelected = true
            listButton.isSelected = false
            handSanitizerButton.isSelected = false
            etcButton.isSelected = false
        case listButton:
            maskButton.isSelected = false
            listButton.isSelected = true
            handSanitizerButton.isSelected = false
            etcButton.isSelected = false
        case handSanitizerButton:
            maskButton.isSelected = false
            listButton.isSelected = false
            handSanitizerButton.isSelected = true
            etcButton.isSelected = false
        case etcButton:
            maskButton.isSelected = false
            listButton.isSelected = false
            handSanitizerButton.isSelected = false
            etcButton.isSelected = true
        default:
            return
        }
    }

}

extension ReportViewController: UITextViewDelegate {
    func placeholderSetting() {
        reportTextView.delegate = self
        reportTextView.text = "정확한 신고는 더 좋은 가게를 만듭니다"
        reportTextView.textColor = .veryLightPink
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.veryLightPink {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "정확한 신고는 더 좋은 가게를 만듭니다"
            textView.textColor = .veryLightPink
        }
    }
}
