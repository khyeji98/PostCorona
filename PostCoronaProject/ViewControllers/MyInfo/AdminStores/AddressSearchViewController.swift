//
//  AddressSearchViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/08/29.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ResultCellDelegate {
    func didSelectAddress(_ sender: UIButton)
}

class AddressSearchViewController: UIViewController, ResultCellDelegate {
    
    var delegate: AddressSearchDelegate?
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    @IBAction func tappedSearchButton(_ sender: UIButton) {
        self.doSearchAddress(keyword: addressTextField.text ?? "", page: 1)
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        if let cell = resultTableView.dequeueReusableCell(withIdentifier: "resultCell") as? ResultCell {
            cell.cellDelegate = self
            cell.cellDelegate?.didSelectAddress(sender)
        }
    }

    private var resultList = [Address]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultList.removeAll()
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        resultTableView.separatorInset = .zero
        resultTableView.separatorStyle = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doSearchAddress(keyword: String, page: Int) {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 346f2cf76936763581213ad0fa4b174b"
        ]
        let parameters: [String:Any] = [
            "query": keyword,
            "page": page,
            "size": 15
        ]
        DispatchQueue.global().async {
            Alamofire.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get, parameters: parameters, headers: headers).responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    print(response.result)
                    print("pageable_count : \(JSON(value)["meta"]["pageable_count"])")
                    print("is_end : \(JSON(value)["meta"]["is_end"])")
                    print("documents : \(JSON(value)["documents"])")
                
                    if let addressList = JSON(value)["documents"].array {
                        for item in addressList {
                            let jibunAddress = item["address_name"].string ?? ""
                            let roadAddress = item["road_address_name"].string ?? ""
                            let placeName = item["place_name"].string ?? ""
                            let x = item["x"].string ?? "unknown"
                            let y = item["y"].string ?? "unknown"
                        
                            self.resultList.append(Address(jibunAddr: jibunAddress, roadAddr: roadAddress, placeName: placeName, x: x, y: y))
                        }
                    }
                    DispatchQueue.main.async {
                        self.resultTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    func didSelectAddress(_ sender: UIButton) {
        let buttonRow = sender.tag
        let tagAddress = resultList[buttonRow]
        delegate?.receiveSelectedAddress(tagAddress.self)

        self.navigationController?.popViewController(animated: true)
    }
}

extension AddressSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultCell
        
        cell.selectionStyle = .none
        cell.cellDelegate = self
        cell.item = self.resultList[indexPath.row]
        cell.selectButton.tag = indexPath.row
        
        return cell
    }
    
}
