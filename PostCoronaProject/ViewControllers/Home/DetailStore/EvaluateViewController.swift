//
//  EvaluateViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/24.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class EvaluateViewController: UIViewController {

    var storeName = String()
    var storeNum = String()
    var category = String()
    var user = String()
    var whatEvaluate = String()
    var grade = Int()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var howLabel: UILabel!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var twoImageView: UIImageView!
    @IBOutlet weak var threeImageView: UIImageView!
    @IBOutlet weak var fourImageView: UIImageView!
    @IBOutlet weak var fiveImageView: UIImageView!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var evaluateTextView: UITextView!
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gradeChanged(_ sender: UISlider) {
        let value = round(sender.value)
        for index in 0...5 {
            if let gradeImage = view.viewWithTag(index) as? UIImageView {
                if index <= Int(value) {
                    gradeImage.image = UIImage(named: "how\(whatEvaluate)1.png")
                } else {
                    gradeImage.image = UIImage(named: "how\(whatEvaluate)0.png")
                }
            }
        }
        self.grade = Int(value)
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        guard let evaluateComment = evaluateTextView.text else { return }
//        guard let whatEvaluate = whatEvaluate else { return }
        
        if evaluateComment == "솔직한 리뷰는 더 좋은 방역 환경을 만듭니다" || evaluateComment == "솔직한 리뷰를 작성해주세요" || evaluateComment == "솔직한 리뷰는 더 좋은 위생 환경을 만듭니다" || self.grade == 0 {
            let alertController = UIAlertController(title: nil, message: "리뷰 작성이 완료되지 않았습니다.", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(yesPressed)
            self.present(alertController, animated: true, completion: nil)
        } else {
            DispatchQueue.global().async {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let todayDate = formatter.string(from: Date())
                
                self.db.collection("store").document(self.storeNum).collection(self.whatEvaluate).document("comment").setData(["\(self.user), \(todayDate)":[evaluateComment, self.user, todayDate, self.grade]])
                
                self.db.runTransaction({(transaction, errorPointer) in
                    let Document: DocumentSnapshot
                    do {
                        try Document = transaction.getDocument(self.db.collection("store").document(self.storeNum))
                    } catch let fetchError as NSError {
                        errorPointer?.pointee = fetchError
                        return nil
                    }
                    //grade
                    guard let grade = Document.data()?["\(self.whatEvaluate)Aver"] as? Int else {
                        let error = NSError(
                            domain: "AppErrorDomain",
                            code: 0,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Unable to retrieve like from snapshot \(Document)"
                            ])
                        errorPointer?.pointee = error
                        return nil
                    }
                    transaction.updateData([self.whatEvaluate: (grade + self.grade)/2], forDocument: self.db.collection("store").document(self.storeNum))
                    // count
                    guard let count = Document.data()?["\(self.whatEvaluate)Count"] as? Int else {
                        let error = NSError(
                            domain: "AppErrorDomain",
                            code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey: "Unable to retrieve like from snapshot \(Document)"
                            ])
                        errorPointer?.pointee = error
                        return nil
                    }
                    return nil
                }) { (object, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("트랜잭션 성공")
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        evaluateTextView.delegate = self
        setUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUI() {
        storeNameLabel.text = self.storeName
        setImage(whatEvaluate)
        switch whatEvaluate {
        case "covid19":
            howLabel.text = "방역 상태는 어떠셨나요?"
            markLabel.text = "방역에 대한 간단한 의견을 남겨주세요!"
            evaluateTextView.text = "솔직한 리뷰는 더 좋은 방역 환경을 만듭니다"
            evaluateTextView.textColor = .veryLightPink
        case "clean":
            howLabel.text = "위생은 어떠셨나요?"
            markLabel.text = "위생에 대한 간단한 의견을 남겨주세요!"
            evaluateTextView.text = "솔직한 리뷰는 더 좋은 위생 환경을 만듭니다"
            evaluateTextView.textColor = .veryLightPink
        case "etc":
            if self.category == "pc" || self.category == "karaoke" {
                howLabel.text = "이용은 어떠셨나요?"
                markLabel.text = "이용에 대한 간단한 의견을 남겨주세요!"
            } else {
                howLabel.text = "맛은 어떠셨나요?"
                markLabel.text = "맛에 대한 간단한 의견을 남겨주세요!"
            }
            evaluateTextView.text = "솔직한 리뷰를 작성해주세요"
            evaluateTextView.textColor = .veryLightPink
        default:
            return
        }
    }
    
    func setImage(_ sender: String) {
        oneImageView.image = UIImage(named: "how\(sender)0.png")
        twoImageView.image = UIImage(named: "how\(sender)0.png")
        threeImageView.image = UIImage(named: "how\(sender)0.png")
        fourImageView.image = UIImage(named: "how\(sender)0.png")
        fiveImageView.image = UIImage(named: "how\(sender)0.png")
        oneImageView.tag = 1
        twoImageView.tag = 2
        threeImageView.tag = 3
        fourImageView.tag = 4
        fiveImageView.tag = 5
    }
}

extension EvaluateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.veryLightPink {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            switch whatEvaluate {
            case "covid19":
                textView.text = "솔직한 리뷰는 더 좋은 방역 환경을 만듭니다"
            case "sanitation":
                textView.text = "솔직한 리뷰는 더 좋은 위생 환경을 만듭니다"
            case "etc":
                textView.text = "솔직한 리뷰를 작성해주세요"
            default:
                return
            }
            textView.textColor = .veryLightPink
        }
    }
}
