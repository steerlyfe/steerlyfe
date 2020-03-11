//
//  CommonProductsListVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 27/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class CommonProductsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonPressedAtPositionDelegate, RefreshProductsListDelegate{
    
    
    let TAG = "CommonProductsListVC"
    let databaseMethods = DatabaseMethods()
    
    var pageTitle : String = ""
    var listData : [ProductDetail] = []
    var userDefaults = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
//        CommonMethods.setTableViewSeperatorColor(tableView: tableView)
        noDataMessage.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UINib(nibName: "ProductListTVC", bundle: nil), forCellReuseIdentifier: "ProductListTVC")
        tableView.register(UINib(nibName: "PaginationTVC", bundle: nil), forCellReuseIdentifier: "PaginationTVC")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        if self.listData.count > 0{
            noDataMessage.isHidden = true
        }else{
            noDataMessage.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        CommonMethods.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: pageTitle)
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTVC", for: indexPath) as! ProductListTVC
        cell.setDetail(data: listData[indexPath.row], delegate: self, position: indexPath.row, databaseMethods: databaseMethods, calledFrom: MyConstants.COMMON_PRODUCT_LIST)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    //    func onButtonPressed(type: String, position: Int) {
    //        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
    //        switch type {
    //        case MyConstants.REMOVE_ITEM:
    //            tableView.reloadData()
    //            break
    //        case MyConstants.REFRESH_DATA:
    //            tableView.reloadData()
    //            break
    //        default:
    //            break
    //        }
    //    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.ADD_TO_CART:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: listData[position].product_id, refreshProductsListDelegate: self)
            break
        case MyConstants.REFRESH_DATA:
            tableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
            break
        default:
            break
        }
    }
    
    func onProductRefreshCalled() {
        CommonMethods.showLog(tag: TAG, message: "onProductRefreshCalled")
        tableView.reloadData()
    }
    
}
