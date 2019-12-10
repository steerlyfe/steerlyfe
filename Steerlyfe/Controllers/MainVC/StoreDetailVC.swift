//
//  StoreDetailVC.swift
//  Steerlyfe
//
//  Created by nap on 04/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//

import UIKit
import SDWebImage

class StoreDetailVC: UIViewController, StoreDetailDelegate, UITableViewDelegate, UITableViewDataSource, ButtonPressedDelegate {
    
    let TAG = "StoreDetailVC"
    var subStoreId : String = ""
    var storeDetail : StoreDetail?
    var totalSections : Int = 0
    
    @IBOutlet weak var bannerImageHeight: NSLayoutConstraint!
    @IBOutlet weak var followTitle: UILabel!
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backArrowImage: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        CommonWebServices.api.getStoreDetail(navigationController: navigationController, subStoreId: subStoreId, delegate: self)
    }
    
    func setUI() {
        self.view.backgroundColor = UIColor.white
        let width = self.view.frame.width
        bannerImageHeight.constant = ( width * 2 ) / 3
        CommonMethods.common.showLog(tag: TAG, message: "width : \(width)")
        CommonMethods.common.showLog(tag: TAG, message: "height : \(bannerImageHeight.constant)")
        bannerImage.isHidden = true
        followView.isHidden = true
        tableView.isHidden = true
        CommonMethods.common.roundCornerView(uiView: followView, cornerRadius: 18.0)
        CommonMethods.common.setTableViewSeperatorColor(tableView: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UINib(nibName: "StoreDetailTopTVC", bundle: nil), forCellReuseIdentifier: "StoreDetailTopTVC")
        tableView.register(UINib(nibName: "StoreReviewTVC", bundle: nil), forCellReuseIdentifier: "StoreReviewTVC")
        tableView.register(UINib(nibName: "CommonButtonTVC", bundle: nil), forCellReuseIdentifier: "CommonButtonTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return storeDetail?.reviews.count ?? 0
//            return 0
        case 2:
            if (storeDetail?.ratingCount ?? 0)  > ( storeDetail?.reviews.count ?? 0){
                return 1
            }else{
                return 0
            }
//            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailTopTVC", for: indexPath) as! StoreDetailTopTVC
                cell.setDetail(data: storeDetail, height: bannerImageHeight.constant, delegate: self)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoreReviewTVC", for: indexPath) as! StoreReviewTVC
                cell.setDetail(data: storeDetail?.reviews[indexPath.row])
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVC", for: indexPath) as! CommonButtonTVC
                cell.setDetail(title: "LOAD MORE", type: "LoadReviews", delegate: self)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalSections
    }
    
    func onStoreDetailReceived(status: String, message: String, data: StoreDetailResponse?) {
        CommonMethods.common.showLog(tag: TAG, message: "status : \(status)")
        CommonMethods.common.showLog(tag: TAG, message: "message : \(message)")
        switch status {
        case "1":
            storeDetail = data?.storeDetail
            bannerImage.sd_setImage(with: URL(string: storeDetail?.bannerUrl ?? "" )) { (image, error, cacheType, url) in
            }
            bannerImage.isHidden = false
            followView.isHidden = false
            tableView.isHidden = false
            totalSections = 3
            tableView.reloadData()
            break
        default:
            MyNavigations.navigation.showCommonMessageDialog(message: message, buttonTitle: "OK")
            break
        }
    }

    @IBAction func followButtonPressed(_ sender: Any) {
        CommonMethods.common.showLog(tag: TAG, message: "followButtonPressed")
    }
    
    @IBAction func backButtomPressed(_ sender: Any) {
        CommonMethods.common.showLog(tag: TAG, message: "backButtomPressed")
        CommonMethods.common.backPressed()
    }
    
    func onButtonPressed(type: String) {
        CommonMethods.common.showLog(tag: TAG, message: "onButtonPressed type : \(type)")
        switch type {
        case "LoadReviews":
            break
        case "MenuPressed":
            MyNavigations.navigation.goToProductList(navigationController: navigationController, type: .storeProducts, pageTitle: "\(storeDetail?.storeName ?? "")'s Products", categoryId: "", subStoreId: storeDetail?.subStoreId ?? "", storeId: storeDetail?.storeId ?? "")
            break
        default:
            break
        }
    }
    
}
