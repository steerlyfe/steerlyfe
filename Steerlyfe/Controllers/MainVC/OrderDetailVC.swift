//
//  OrderDetailVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 06/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonPressedAtPositionDelegate, OnProcessCompleteDelegate {
    
    let TAG = "OrderDetailVC"
    
    var orderDetail : OrderDetail?
    var delegate : OnProcessCompleteDelegate?
    
    @IBOutlet weak var orderInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rateNowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderInfo.text = "Order # \(orderDetail?.order_id ?? "") . Placed On \(CommonMethods.getSpecialFormattedDate(format: "dd/MM/yyyy", timeStamp: orderDetail?.order_time ?? NSDate().timeIntervalSince1970))".uppercased()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
       
    @IBAction func backButtonPressed(_ sender: Any) {
        CommonMethods.dismissCurrentViewController()
    }
    
    func setUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "OrderDetailProductInfoTVC", bundle: nil), forCellReuseIdentifier: "OrderDetailProductInfoTVC")
        tableView.register(UINib(nibName: "OrderDetailBottomInfoTVC", bundle: nil), forCellReuseIdentifier: "OrderDetailBottomInfoTVC")
        tableView.register(UINib(nibName: "OrderDetailTopInfoTVC", bundle: nil), forCellReuseIdentifier: "OrderDetailTopInfoTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tableView.reloadData()
        checkAndSHowRateButton()
    }
    
    func checkAndSHowRateButton() {
        rateNowButton.isHidden = false
//        if orderDetail?.order_status == MyConstants.ORDER_STATUS_COMPLETED{
//            if orderDetail?.order_rating == 0.0{
//                rateNowButton.isHidden = false
//            }else{
//                rateNowButton.isHidden = true
//            }
//        }else{
//            rateNowButton.isHidden = true
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return orderDetail?.order_info.count ?? 0
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailTopInfoTVC", for: indexPath) as! OrderDetailTopInfoTVC
            cell.setDetail(addressDetail: orderDetail?.address_detail, productCount: orderDetail?.order_info.count ?? 0)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailProductInfoTVC", for: indexPath) as! OrderDetailProductInfoTVC
            cell.setDetail(data: orderDetail?.order_info[indexPath.row], delegate: self, position: indexPath.row)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailBottomInfoTVC", for: indexPath) as! OrderDetailBottomInfoTVC
            cell.setDetail(data: orderDetail)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailBottomInfoTVC", for: indexPath) as! OrderDetailBottomInfoTVC
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.BUY_AGAIN_PRESSED:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: orderDetail?.order_info[position].product_id, refreshProductsListDelegate: nil)
            break
        default:
            break
        }
    }
    
    
    @IBAction func rateNowPressed(_ sender: Any) {
        MyNavigations.goToRateOrder(navigationController: navigationController, order_id: orderDetail?.order_id, delegate: self)
    }
    
    func onProcessComplete(type: String, status: String, message: String) {
        switch type {
        case MyConstants.SUBMIT_ORDER_RATING:
            switch status {
            case "1":
                CommonMethods.dismissCurrentViewController()
                DispatchQueue.main.async {
                    self.delegate?.onProcessComplete(type: MyConstants.SUBMIT_ORDER_RATING, status: "1", message: message)
                }
                break
            default:
                MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
                break
            }
            break
        default:
            break
        }
    }
    

}
