//
//  OwnerCommentViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/26.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class OwnerCommentViewController: UIViewController {

    var ownerComment = String()
    var storeNum = String()
    
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var ownerCommentLabel: UILabel!
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setData() {
        ownerCommentLabel.text = ownerComment
        Storage.storage().reference(forURL: "gs://together-at001.appspot.com/\(storeNum).png").downloadURL(completion: { (url, error) in
            if let url = url {
                self.commentImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default.png"))
            }
        })
    }

}
