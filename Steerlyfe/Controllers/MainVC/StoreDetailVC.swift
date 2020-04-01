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
    var bannerHeight : CGFloat = 0.0
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var followTitle: UILabel!
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backArrowImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        CommonWebServices.api.getStoreDetail(navigationController: navigationController, subStoreId: subStoreId, delegate: self)
    }
    
    func setUI() {
        var color = UIColor.black
        color = color.withAlphaComponent(0.05)
        headerView.backgroundColor = color
        self.view.backgroundColor = UIColor.white
        let width = self.view.frame.width
        bannerHeight = ( width * 2.0 ) / 3.0
        followView.isHidden = true
        tableView.isHidden = true
        CommonMethods.roundCornerView(uiView: followView, cornerRadius: 18.0)
        CommonMethods.setTableViewSeperatorColor(tableView: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UINib(nibName: "StoreDetailTopInfoTVC", bundle: nil), forCellReuseIdentifier: "StoreDetailTopInfoTVC")
        tableView.register(UINib(nibName: "CommonButtonTVC", bundle: nil), forCellReuseIdentifier: "CommonButtonTVC")
        tableView.register(UINib(nibName: "StoreDetailRecentlyPostedTVC", bundle: nil), forCellReuseIdentifier: "StoreDetailRecentlyPostedTVC")
        tableView.register(UINib(nibName: "StoreDetailInfoTVC", bundle: nil), forCellReuseIdentifier: "StoreDetailInfoTVC")
        tableView.register(UINib(nibName: "StoreReviewTVC", bundle: nil), forCellReuseIdentifier: "StoreReviewTVC")
        //        tableView.register(UINib(nibName: "StoreDetailTopTVC", bundle: nil), forCellReuseIdentifier: "StoreDetailTopTVC")
        //        tableView.register(UINib(nibName: "StoreReviewTVC", bundle: nil), forCellReuseIdentifier: "StoreReviewTVC")
        //        tableView.register(UINib(nibName: "CommonButtonTVC", bundle: nil), forCellReuseIdentifier: "CommonButtonTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 0
        case 3:
            return 1
        case 4:
            return storeDetail?.reviews.count ?? 0
        case 5:
            if (storeDetail?.ratingCount ?? 0)  > ( storeDetail?.reviews.count ?? 0){
                return 1
            }else{
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailTopInfoTVC", for: indexPath) as! StoreDetailTopInfoTVC
            cell.setDetail(data: storeDetail, height: bannerHeight, delegate: self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVC", for: indexPath) as! CommonButtonTVC
            cell.setDetail(title: "Menu".uppercased(), type: MyConstants.STORE_MENU, delegate: self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailRecentlyPostedTVC", for: indexPath) as! StoreDetailRecentlyPostedTVC
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailInfoTVC", for: indexPath) as! StoreDetailInfoTVC
            cell.setDetail(data: storeDetail, delegate: self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreReviewTVC", for: indexPath) as! StoreReviewTVC
            cell.setDetail(data: storeDetail?.reviews[indexPath.row])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVC", for: indexPath) as! CommonButtonTVC
            cell.setDetail(title: "Load More".uppercased(), type: MyConstants.LOAD_REVIEWS, delegate: self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVC", for: indexPath) as! CommonButtonTVC
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        //        switch indexPath.section {
        //        case 0:
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreDetailTopTVC", for: indexPath) as! StoreDetailTopTVC
        //            cell.setDetail(data: storeDetail, height: bannerImageHeight.constant, delegate: self)
        //            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        //            return cell
        //        case 1:
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreReviewTVC", for: indexPath) as! StoreReviewTVC
        //            cell.setDetail(data: storeDetail?.reviews[indexPath.row])
        //            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        //            return cell
        //        default:
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonButtonTVC", for: indexPath) as! CommonButtonTVC
        //            cell.setDetail(title: "LOAD MORE", type: "LoadReviews", delegate: self)
        //            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        //            return cell
        //        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalSections
    }
    
    func onStoreDetailReceived(status: String, message: String, data: StoreDetailResponse?) {
        CommonMethods.showLog(tag: TAG, message: "status : \(status)")
        CommonMethods.showLog(tag: TAG, message: "message : \(message)")
        switch status {
        case "1":
            storeDetail = data?.storeDetail
            followView.isHidden = false
            tableView.isHidden = false
            totalSections = 6
            tableView.reloadData()
            break
        default:
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
            break
        }
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "followButtonPressed")
    }
    
    @IBAction func backButtomPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "backButtomPressed")
        CommonMethods.backPressed()
    }
    
    func onButtonPressed(type: String) {
        CommonMethods.showLog(tag: TAG, message: "onButtonPressed type : \(type)")
        switch type {
        case MyConstants.LOAD_REVIEWS:
            break
        case MyConstants.STORE_MENU:
            MyNavigations.goToProductList(navigationController: navigationController, type: .storeProducts, pageTitle: "\(storeDetail?.storeName ?? "")'s Products", categoryId: "", subStoreId: storeDetail?.subStoreId ?? "", storeId: storeDetail?.storeId ?? "")
            break
        default:
            break
        }
    }
    
}
