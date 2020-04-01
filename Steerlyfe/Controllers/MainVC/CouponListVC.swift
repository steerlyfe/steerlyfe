//
//  CouponListVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 30/03/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class CouponListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonPressedAtPositionDelegate, CouponsListDelegate{
    
    
    let TAG = "CouponListVC"
    let databaseMethods = DatabaseMethods()
    
    var listData : [CouponDetail] = []
    var userDefaults = UserDefaults.standard
    var applyCouponDelegate : ApplyCouponDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getData()
    }
    
    func setUI(){
        self.automaticallyAdjustsScrollViewInsets = false
        noDataMessage.isHidden = true
        noDataMessage.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UINib(nibName: "CouponListTVC", bundle: nil), forCellReuseIdentifier: "CouponListTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        CommonMethods.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: "Available Coupons")
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponListTVC", for: indexPath) as! CouponListTVC
        cell.setDetail(data: listData[indexPath.row], delegate: self, position: indexPath.row)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.APPLY_COUPON:
            CommonWebServices.api.checkCouponWithOrder(navigationController: navigationController, coupon_id: listData[position].couponId ?? "", delegate: applyCouponDelegate, closeViewController: true)
            break
        default:
            break
        }
    }
    
    func getData()  {
        noDataMessage.isHidden = true
        let cartProducts = databaseMethods.getAllCartProducts()
        var storeIds : [String] = []
        var jsonCollection = [Any]()
        for loopValue in cartProducts {
            if let storeId = loopValue.store_id{
                if !storeIds.contains(storeId){
                    storeIds.append(storeId)
                    jsonCollection.append(storeId)
                }
            }
        }
        let storeIdsJsonString = CommonMethods.prepareJson(from: jsonCollection) ?? "[]"
        CommonMethods.showLog(tag: TAG, message: "storeIdsJsonString : \(storeIdsJsonString)")
        CommonWebServices.api.getCouponList(navigationController: navigationController, storeIdsJsonString: storeIdsJsonString, delegate: self)
    }
    
    func onCouponsListReceived(status: String, message: String, data: AllCouponsListResponse?) {
        CommonMethods.showLog(tag: TAG, message: "SIZE : \(data?.couponList.count ?? 0)")
        switch status {
        case "1":
            listData = data?.couponList ?? []
            if self.listData.count > 0{
                noDataMessage.isHidden = true
            }else{
                noDataMessage.isHidden = false
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            break
        default:
            CommonMethods.dismissLoadingAndShowMessage(message: message, buttonTitle: "OK")
            break
        }
    }
    
//    func onCouponApplied(applyCouponResponse: ApplyCouponResponse?) {
//        if let response = applyCouponResponse{
//            if let status = response.status{
//                switch status {
//                case "1":
//                    KVNProgress.showSuccess(withStatus: "Coupon applied successfully") {
//                        self.applyCouponDelegate?.onCouponApplied(applyCouponResponse: response)
//                        CommonMethods.dismissCurrentViewController()
//                    }
//                    break
//                case "0":
//                    MyNavigations.showCommonMessageDialog(message: response.message ?? MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
//                    break
//                case "10":
//                    CommonMethods.logout(navigationController: navigationController)
//                    break
//                default:
//                    MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
//                    break
//                }
//            }else{
//                MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
//            }
//        }else{
//            MyNavigations.showCommonMessageDialog(message: MyConstants.STATIC_ERROR_MESSAGE, buttonTitle: "Ok")
//        }
//    }
}
