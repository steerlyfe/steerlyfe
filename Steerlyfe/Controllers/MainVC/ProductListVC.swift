//
//  ProductListVC.swift
//  Steerlyfe
//
//  Created by nap on 03/10/19.
//  Copyright © 2019 napworks. All rights reserved.
//
import UIKit

class ProductListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ProductsListDelegate, ButtonPressedAtPositionDelegate, UISearchBarDelegate{
    
    let TAG = "ProductListVC"
    let refreshControl = UIRefreshControl()
    let databaseMethods = DatabaseMethods()
    
    var refresh = true
    var type : ProductListType = .categoryProducts
    var pageTitle : String = ""
    var categoryId : String = ""
    var subStoreId : String = ""
    var storeId : String = ""
    var listData : [ProductDetail] = []
    var isLoading = false
    var isLast = false
    var userDefaults = UserDefaults.standard
    var showLoading : Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getOnLoadData()
    }
    
    func setUI(){
        CommonMethods.common.setTableViewSeperatorColor(tableView: tableView)
        noDataMessage.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.register(UINib(nibName: "ProductListTVC", bundle: nil), forCellReuseIdentifier: "ProductListTVC")
        tableView.register(UINib(nibName: "PaginationTVC", bundle: nil), forCellReuseIdentifier: "PaginationTVC")
        tableView.delegate = self
        tableView.dataSource = self
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        tableView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        searchBar.delegate = self
        switch type {
        case .searchProducts:
            searchView.isHidden = false
            searchBar.becomeFirstResponder()
            break
        default:
            searchView.isHidden = true
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        CommonMethods.common.setNavigationBar(navigationController: navigationController, navigationItem: navigationItem, title: pageTitle)
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func getOnLoadData()  {
        refreshControl.beginRefreshing()
        getAllData()
    }
    
    @objc func onRefresh(_ sender : Any) {
        refresh = true
        getAllData()
    }
    
    func getAllData()  {
        noDataMessage.isHidden = true
        var paginationCount = 0
        if refresh {
            paginationCount = 0
        }else{
            paginationCount = listData.count
        }
        isLoading = true
        CommonMethods.common.showLog(tag: TAG, message: "paginationCount : \(paginationCount)")
        CommonMethods.common.showLog(tag: TAG, message: "refresh : \(refresh)")
        switch type {
        case .categoryProducts:
            CommonWebServices.api.getCategoryProducts(navigationController: navigationController, categoryId: categoryId, count: paginationCount, delegate: self)
            break
        case .searchProducts:
            if let text = searchBar.text{
                if text.count > 1{
                    CommonWebServices.api.searchProduct(navigationController: navigationController, productName: text, count: paginationCount, delegate: self)
                }else{
                    refreshControl.endRefreshing()
                }
            }else{
                refreshControl.endRefreshing()
            }
            break
        case .storeProducts:
            CommonWebServices.api.getStoreProducts(navigationController: navigationController, storeId: storeId, subStoreId: subStoreId, count: paginationCount, delegate: self)
            break
        }
    }
    
    func onProductListReceived(status: String, message: String, data: CategoryProductsResponse?) {
        showLoading = false
        self.refreshControl.endRefreshing()
        isLoading = false
        switch status {
        case "1":
            if refresh{
                self.listData = []
            }
            data?.productList.forEach({(productDetail : ProductDetail)in
                let quantity = databaseMethods.getProductQuantity(productId: productDetail.product_id ?? "")
                productDetail.quantity = quantity ?? 0
                self.listData.append(productDetail)
            })
            refresh = false
            if (data?.productList.count ?? 0) < (data?.perPageItems ?? 10){
                isLast = true
            }else{
                showLoading = true
                isLast = false
            }
            self.tableView.reloadData()
            if self.listData.count > 0{
                noDataMessage.isHidden = true
            }else{
                noDataMessage.isHidden = false
            }
            break
        default:
            MyNavigations.navigation.showCommonMessageDialog(message: message, buttonTitle: "OK")
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return listData.count
        case 1:
            return showLoading ? 1 : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            switch indexPath.section {
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaginationTVC", for: indexPath) as! PaginationTVC
                cell.setDetail()
                addLoadingCell()
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTVC", for: indexPath) as! ProductListTVC
                cell.setDetail(data: listData[indexPath.row], delegate: self, position: indexPath.row, databaseMethods: databaseMethods)
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func addLoadingCell() {
        if !isLoading && !isLast{
            getAllData()
        }
    }
    
    func onButtonPressed(type: String, position: Int) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        CommonMethods.common.showLog(tag: TAG, message: "searchBarSearchButtonClicked")
        if let text = searchBar.text{
            if text.count > 1{
                refresh = true
                refreshControl.beginRefreshing()
                getAllData()
            }else{
                MyNavigations.navigation.showCommonMessageDialog(message: "Enter at least 2 characters", buttonTitle: "OK")
            }
        }else{
            MyNavigations.navigation.showCommonMessageDialog(message: "Enter product name", buttonTitle: "OK")
        }
    }
}
