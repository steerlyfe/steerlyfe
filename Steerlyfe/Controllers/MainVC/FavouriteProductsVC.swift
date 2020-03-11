//
//  FavouriteProductsVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 09/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class FavouriteProductsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonPressedAtPositionDelegate, RefreshProductsListDelegate {
    
    let TAG = "FavouriteProductsVC"
    let databaseMethods = DatabaseMethods()
    
    var keyboardSize : CGFloat = 0
    var data : [ProductDetail] = []
    var bottomMessageType = MyConstants.CART_LIST
        
    @IBOutlet weak var bottomMessageButton: UIButton!
    @IBOutlet weak var bottomMessageLabel: UILabel!
    @IBOutlet weak var bottomMessageView: UIView!
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        refreshData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        CommonMethods.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: "Favorite Products")
    }
    
    func setUI() {
        bottomMessageView.isHidden = true
        CommonMethods.addRoundCornerFilled(uiview: bottomMessageButton, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 5.0)
        tableView.register(UINib(nibName: "ProductListTVC", bundle: nil), forCellReuseIdentifier: "ProductListTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        //        CommonMethods.setTableViewSeperatorColor(tableView: tableView)
        CommonMethods.setTableViewSeperatorTransparentColor(tableView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.0)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTVC", for: indexPath) as! ProductListTVC
        cell.setDetail(data: data[indexPath.row], delegate: self, position: indexPath.row, databaseMethods: databaseMethods, calledFrom: MyConstants.FAVOURITE_LIST)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.REMOVE_ITEM:
            data.remove(at: position)
            tableView.reloadData()
            break
        case MyConstants.REFRESH_DATA:
            refreshData()
            break
        case MyConstants.ADD_TO_CART:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: data[position].product_id, refreshProductsListDelegate: self)
//            bottomMessageLabel.text = "Item added to cart"
//            bottomMessageButton.setTitle("Cart", for: .normal)
//            bottomMessageView.isHidden = false
//            bottomMessageButton.isHidden = false
//            CommonMethods.fadeIn(view: bottomMessageView)
            break
        case MyConstants.DELETE_FAVOURITE:
            bottomMessageLabel.text = "Item removed from favorites"
            bottomMessageButton.isHidden = true
            bottomMessageView.isHidden = false
            CommonMethods.fadeIn(view: bottomMessageView)
            break
        default:
            break
        }
    }
    
    func refreshData() {
        data = databaseMethods.getAllFavouriteProducts()
        if data.count > 0{
            noDataMessage.isHidden = true
        }else{
            noDataMessage.isHidden = false
        }
        tableView.reloadData()
    }
    
    @IBAction func bottomMessageButtonPressed(_ sender: Any) {
        if bottomMessageType == MyConstants.CART_LIST{
            MyNavigations.goToCart(navigationController: navigationController, showBackArrow: true)
        }
    }
    
    func onProductRefreshCalled() {
        tableView.reloadData()
    }
    
    
}
