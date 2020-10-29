//
//  RegionFilterViewController.swift
//  PostCoronaProject
//
//  Created by 김혜지 on 2020/10/27.
//  Copyright © 2020 김혜지. All rights reserved.
//

import UIKit
import Firebase

class RegionFilterViewController: UIViewController {

    let db = Firestore.firestore()
    let first = ["전체", "강원", "경기", "경남", "경북", "광주", "대구", "대전", "부산", "서울", "세종특별자치시", "울산", "인천", "전남", "전북", "제주특별자치도", "충남", "충북"]
    let second = ["강원":["강릉시","고성군","동해시","삼척시","속초시","양구군","양양군","영원군","원주시","인제군","정선군","철원군","춘천시","태백시","평창군","홍천군","화천군","횡성군"],"경기":["가평군","고양시 일산서구", "고양시 덕양구","고양시 일산동구","과천시","광명시","광주시","구리시","군포시","김포시","남양주시","동두천시","부천시","성남시 분당구","성남시 수정구","성남시 중원구","수원시 권선구","수원시 영통구","수원시 장안구","수원시 팔달구","시흥시","안산시 단원구","안산시 상록구","안성시","안양시 동안구","안양시 만안구","양주시","양평군","여주시","연천군","오산시","용인시 기흥구","용인시 수지구","용인시 처인구","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시"],"경남":["거제시","거창군","고성군","김해시","남해군","마산회원구","밀양시","산청군","양산시","의령군","진주시","진해구","창녕군","창원시 마산합포구","창원시 성산구","창원시 의창구","통영시","하동군","함안군","함양군","합천군"],"경북":["경산시","경주시","고령군","구미시","군위군","김천시","문경시","봉화군","상주시","성주군","안동시","영덕군","영양군","영주시","영천시","예천군","울릉군","울진군","의성군","청도군","청송군","칠곡군","포항시 남구","포항시 북구"],"광주":["광산구","남구","동구","북구","서구"],"대구":["남구","달서구","달성군","동구","북구","서구","수성구","중구"],"대전":["대덕구","동구","서구","유성구","중구"],"부산":["강서구","금정구","기장군","남구","동구","동래구","부산진구","북구","사상구","사하구","서구","수영구","연제구","영도구","중구","해운대구"],"서울":["강남구","강동구","강북구","강서구","관악구","광진구","구로구","금천구","노원구","도봉구","동대문구","동작구","마포구","서대문구","서초구","성동구","성북구","송파구","양천구","영등포구","용산구","은평구","종로구","중구","증랑구"],"세종특별자치시":["세종특별자치시"],"울산":["남구","동구","북구","울주군","중구"],"인천":["강화군","계양구","남동구","동구","미추홀구","부평구","서구","연수구","옹진구","중구"],"전남":["강진군","고흥군","곡성군","광양시","구례군","나주시","담양군","목포시","무안군","보성군","순천시","신안군","여수시","영광군","영암군","완도군","장선군","장흥군","진도군","함평군","해남군"],"전북":["고창군","군산시","김제시","남원시","무주군","부안군","순창군","완주군","익산시","임실군","장수군","전주시 덕진구","전주시 완산구","정읍시","진안군"],"제주특별자치도":["서귀포시","제주시"],"충남":["계룡시","공주시","금산군","논산시","당진시","보령시","부여군","서산시","서천군","아산시","예산군","천안시 동남구","천안시 서북구","청양군","태안군","홍성군"],"충북":["괴산군","단양군","보은군","영동군","옥천군","음성군","제천시","증평군","진천군","청주시 상당구","청주시 서원구","청주시 청원구","청주시 흥덕구","충주시"]]
    var nowSecond = [String]()
    var oldRegion: String?
    var selectedFirst = Int()
    var selectedSecond = Int()
    var finalFirstRegion = String()
    
    var delegate: RegionFilteredDelegate?
    
    @IBOutlet weak var firstRegionTableView: UITableView!
    @IBOutlet weak var secondRegionTableView: UITableView!
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedOkButton(_ sender: UIButton) {
        if ((second[finalFirstRegion]?.contains(nowSecond[selectedSecond])) != nil) { // second까지 선택함
            delegate?.loadRegionFilterData("\(first[selectedFirst]) \(nowSecond[selectedSecond])")
        } else if finalFirstRegion == "전체" {
            delegate?.loadRegionFilterData("total")
        } else { // second 선택안함
            delegate?.loadRegionFilterData(finalFirstRegion)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstRegionTableView.delegate = self
        firstRegionTableView.dataSource = self
        secondRegionTableView.delegate = self
        secondRegionTableView.dataSource = self
    }
    
    func getSecondRegion(_ sender: Int) {
        selectedFirst = sender
        finalFirstRegion = first[sender]
        if sender != 0 {
            nowSecond = second[first[sender]]!
        } else {
            nowSecond.removeAll()
        }
        DispatchQueue.main.async {
            self.secondRegionTableView.reloadData()
        }
    }
}

extension RegionFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case firstRegionTableView:
            if indexPath.row != 0 {
                getSecondRegion(indexPath.row)
            }
        case secondRegionTableView:
            selectedSecond = indexPath.row
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case firstRegionTableView:
            return first.count
        case secondRegionTableView:
            return nowSecond.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case firstRegionTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstRegionCell", for: indexPath) as! FirstRegionTableViewCell
            let region = first[indexPath.row]
            cell.firstRegionLabel.text = region
            return cell
        case secondRegionTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondRegionCell", for: indexPath) as! SecondRegionTableViewCell
            let region = nowSecond[indexPath.row]
            cell.secondRegionLabel.text = region
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FirstRegionCell", for: indexPath) as! FirstRegionTableViewCell
            return cell
        }
    }
}
