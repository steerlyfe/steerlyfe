//
//  OrderHistoryVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 06/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class OrderHistoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, OrderHistoryResponseDelegate, ButtonPressedAtPositionDelegate, OnProcessCompleteDelegate {
    
    let TAG = "OrderHistoryVC"
    let refreshControl = UIRefreshControl()
    
    var ordersList : [OrderDetail] = []
    var oldProducts : [ProductDetail] = []
    var refresh = true
    var isLoading = false
    var isLast = false
    var showLoading : Bool = false
    
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        KVNProgress.show()
        getAllData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        CommonMethods.dismissCurrentViewController()
    }
    
    func setUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "OldProductsTVC", bundle: nil), forCellReuseIdentifier: "OldProductsTVC")
        tableView.register(UINib(nibName: "OrderListTitleTVC", bundle: nil), forCellReuseIdentifier: "OrderListTitleTVC")
        tableView.register(UINib(nibName: "OrderListTVC", bundle: nil), forCellReuseIdentifier: "OrderListTVC")
        tableView.register(UINib(nibName: "PaginationTVC", bundle: nil), forCellReuseIdentifier: "PaginationTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tableView.reloadData()
        noDataMessage.isHidden = true
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
    }
    
    @objc func onRefresh(_ sender : Any) {
        refresh = true
        getAllData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return oldProducts.count > 0 ? 1 : 0
        case 1:
            return ordersList.count > 0 ? 1 : 0
        case 2:
            return ordersList.count
        case 3:
            return showLoading ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OldProductsTVC", for: indexPath) as! OldProductsTVC
            cell.setDetail(products: oldProducts, delegate : self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTitleTVC", for: indexPath) as! OrderListTitleTVC
            cell.setDetail(title: "Orders".uppercased())
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTVC", for: indexPath) as! OrderListTVC
            cell.setDetail(data: ordersList[indexPath.row], delegate: self, position: indexPath.row)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaginationTVC", for: indexPath) as! PaginationTVC
            cell.setDetail()
            addLoadingCell()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTitleTVC", for: indexPath) as! OrderListTitleTVC
            cell.setDetail(title: "")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func addLoadingCell() {
        if !isLoading && !isLast{
            getAllData()
        }
    }
    
    func getAllData()  {
        noDataMessage.isHidden = true
        var paginationCount = 0
        if refresh {
            paginationCount = 0
        }else{
            paginationCount = ordersList.count
        }
        isLoading = true
        CommonMethods.showLog(tag: TAG, message: "paginationCount : \(paginationCount)")
        CommonMethods.showLog(tag: TAG, message: "refresh : \(refresh)")
        CommonWebServices.api.orderHistory(navigationController: navigationController, count: paginationCount, delegate: self)
    }
    
    func onOrderHistoryReceived(status: String, message: String, data: OrderHistoryResponse?) {
        CommonMethods.showLog(tag: TAG, message: "onOrderHistoryReceived status : \(status)" )
        CommonMethods.showLog(tag: TAG, message: "onOrderHistoryReceived message : \(message)" )
        showLoading = false
        self.refreshControl.endRefreshing()
        isLoading = false
        switch status {
        case "1":
            if KVNProgress.isVisible(){
                KVNProgress.dismiss {
                    self.handleResponseData(data: data)
                }
            }else{
                handleResponseData(data: data)
            }
            break
        default:
            if KVNProgress.isVisible(){
                KVNProgress.dismiss {
                    MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
                }
            }else{
                MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
            }
            break
        }
    }
    
    func handleResponseData(data: OrderHistoryResponse?) {
        CommonMethods.showLog(tag: TAG, message: "handleResponseData called refresh : \(refresh)")
        if refresh{
            self.ordersList = []
            self.oldProducts = []
            self.oldProducts = data?.productList ?? []
        }
        data?.orderList.forEach({(orderDetail : OrderDetail)in
            self.ordersList.append(orderDetail)
        })
        refresh = false
        if (data?.orderList.count ?? 0) < (data?.perPageItems ?? 10){
            isLast = true
        }else{
            showLoading = true
            isLast = false
        }
        self.tableView.reloadData()
        if self.ordersList.count > 0{
            noDataMessage.isHidden = true
        }else{
            noDataMessage.isHidden = false
        }
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.VIEW_ORDER_DETAIL:
            MyNavigations.goToOrderDetail(navigationController: navigationController, orderDetail: ordersList[position], delegate: self)
            break
        case MyConstants.VIEW_PRODUCT_DETAIL:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: oldProducts[position].product_id, refreshProductsListDelegate: nil)
            break
        case MyConstants.ADD_TO_CART:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: oldProducts[position].product_id, refreshProductsListDelegate: nil)
            break
        case MyConstants.VIEW_ALL_PRODUCTS:
            MyNavigations.goToPreviousOrderProducts(navigationController: navigationController)
            break
        default:
            break
        }
    }
    
    func onProcessComplete(type: String, status: String, message: String) {
        switch type {
        case MyConstants.SUBMIT_ORDER_RATING:
            switch status {
            case "1":
                KVNProgress.show()
                refresh = true
                getAllData()
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
