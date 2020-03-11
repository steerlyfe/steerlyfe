//
//  ProductDetailVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 13/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController, ProductDetailDelegate, UITableViewDelegate, UITableViewDataSource, ButtonPressedAtPositionDelegate, OnProcessCompleteDelegate {
    
    let TAG = "ProductDetailVC"
    let databaseMethods = DatabaseMethods()
    
    var productId : String = ""
    var totalSections = 0
    var productDetail : ProductDetail?
    var bottomMessageType : String = MyConstants.FAVOURITE_LIST
    var selectedPosition : Int = 0
    var additionalFeaturesAvailable = false
    var sellersCount = 0
    var refreshProductsListDelegate : RefreshProductsListDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomMessageButton: UIButton!
    @IBOutlet weak var bottomMessageLabel: UILabel!
    @IBOutlet weak var bottomMessageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        CommonWebServices.api.getProductDetail(navigationController: navigationController, productId: productId, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func onProductDetailReceived(status: String, message: String, data: ProductDetailResponse?) {
        CommonMethods.showLog(tag: TAG, message: "status : \(status)")
        CommonMethods.showLog(tag: TAG, message: "message : \(message)")
        switch status {
        case "1":
            totalSections = 7
            productDetail = data?.productDetail
            let categories = productDetail?.product_categories ?? []
            if categories.count > 0{
                var categoryText = ""
                var count = 0
                categories.forEach({ (categoryDetail) in
                    if let categoryName = categoryDetail.categoryName{
                        categoryText = "\(categoryText)\(categoryName)"
                        if count < categories.count - 1{
                            categoryText = "\(categoryText), "
                        }
                    }
                    count = count + 1
                })
                productDetail?.product_info.insert(ProductInfo(type: "Category".uppercased(), value: categoryText), at: 0)
            }
            if productDetail?.additional_features.count ?? 0 > 0{
                additionalFeaturesAvailable = true
                sellersCount = productDetail?.additional_features[selectedPosition].sellers.count ?? 0
            }else{
                additionalFeaturesAvailable = false
                sellersCount = 0
            }
//            productDetail?.additional_features.forEach({ (additionalFeatures) in
//                additionalFeatures.sellers.forEach { (sellerDetail) in
//                    CommonMethods.showLog(tag: self.TAG, message: "name : \(sellerDetail.name)")
//                    CommonMethods.showLog(tag: self.TAG, message: "address : \(sellerDetail.address)")
//                }
//            })
            tableView.reloadData()
            break
        default:
            MyNavigations.showCommonMessageDialog(message: message, buttonTitle: "OK")
            break
        }
    }
    
    func setUI() {
        bottomMessageView.isHidden = true
        CommonMethods.addRoundCornerFilled(uiview: bottomMessageButton, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 5.0)        
        tableView.register(UINib(nibName: "ProductDetailInfoTVC", bundle: nil), forCellReuseIdentifier: "ProductDetailInfoTVC")
        tableView.register(UINib(nibName: "ProductAdditionalFeaturesTVC", bundle: nil), forCellReuseIdentifier: "ProductAdditionalFeaturesTVC")
        tableView.register(UINib(nibName: "ProductCommonTitleTVC", bundle: nil), forCellReuseIdentifier: "ProductCommonTitleTVC")
        tableView.register(UINib(nibName: "ProductSellerDetailTVC", bundle: nil), forCellReuseIdentifier: "ProductSellerDetailTVC")
        tableView.register(UINib(nibName: "ProductInfoTVC", bundle: nil), forCellReuseIdentifier: "ProductInfoTVC")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.1)
        tableView.reloadData()
        tableView.separatorStyle = .none
        //        tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return additionalFeaturesAvailable ? 1 : 0
        case 2:
            return 1
        case 3:
            var count = 0
            if productDetail?.additional_features.count ?? 0 > 0{
                count = productDetail?.additional_features[selectedPosition].sellers.count ?? 0
            }
            return count
        case 4:
            return (productDetail?.product_info.count ?? 0) > 0 ? 1 : 0
        case 5:
            return productDetail?.product_info.count ?? 0
        case 6:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        CommonMethods.showLog(tag: TAG, message: "section : \(indexPath.section)")
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailInfoTVC", for: indexPath) as! ProductDetailInfoTVC
            cell.setDetail(data: productDetail, delegate: self, databaseMethods: databaseMethods)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAdditionalFeaturesTVC", for: indexPath) as! ProductAdditionalFeaturesTVC
            cell.setDetail(additionalFeatures: productDetail?.additional_features,selectedPosition: selectedPosition, delegate: self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSellerDetailTVC", for: indexPath) as! ProductSellerDetailTVC
            cell.setDetail(uiViewController: self, productDetail: productDetail, additionalFeatureIndex: selectedPosition, sellerDetailIndex: indexPath.row, databaseMethods: databaseMethods, delegate: self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductInfoTVC", for: indexPath) as! ProductInfoTVC
            CommonMethods.showLog(tag: TAG, message: "ProductInfoTVC : \(indexPath.row)")
            cell.setDetail(data: productDetail?.product_info[indexPath.row])
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCommonTitleTVC", for: indexPath) as! ProductCommonTitleTVC
            if indexPath.section == 2{
                if sellersCount > 0{
                    cell.setDetail(title: "Choose a Seller".uppercased())
                }else{
                    cell.setDetail(title: "No Seller Available".uppercased())
                }
            }else if indexPath.section == 4{
                cell.setDetail(title: "Product Info".uppercased())
            }else{
                cell.setDetail(title: "")
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        CommonMethods.dismissCurrentViewController()
    }
    
    func onProcessComplete(type: String, status: String, message: String) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) status : \(status) message : \(message)")
        switch type {
        case MyConstants.ADD_TO_CART:
            bottomMessageLabel.text = "Item added to cart"
            bottomMessageButton.setTitle("Cart", for: .normal)
            bottomMessageView.isHidden = false
            CommonMethods.fadeIn(view: bottomMessageView)
            bottomMessageType = MyConstants.CART_LIST
            refreshProductsListDelegate?.onProductRefreshCalled()
            break
        case MyConstants.REFRESH_PRODUCT_LIST_DATA:
            refreshProductsListDelegate?.onProductRefreshCalled()
            break
        default:
            break
        }
    }
    
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.ADD_TO_FAVOURITES:
            var showMessage = false
            if databaseMethods.isProductFavourite(productId: productDetail?.product_id ?? "") ?? false{
                if databaseMethods.deleteFavouriteProduct(productId: productDetail?.product_id ?? ""){
                    bottomMessageLabel.text = "Item removed from favorites"
                    showMessage = true
                }
            }else{
                if databaseMethods.addProductInFavourite(productDetail: productDetail){
                    bottomMessageLabel.text = "Item added to favorites"
                    showMessage = true
                }
            }
            if showMessage{
                bottomMessageButton.setTitle("Favorites", for: .normal)
                bottomMessageView.isHidden = false
                CommonMethods.fadeIn(view: bottomMessageView)
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                bottomMessageType = MyConstants.FAVOURITE_LIST
            }
            break
        case MyConstants.ADDITIONAL_FEATURE_CLICKED:
            selectedPosition = position
            sellersCount = productDetail?.additional_features[selectedPosition].sellers.count ?? 0
            tableView.reloadData()
            break
        default:
            break
        }
    }
    
    @IBAction func bottomButtonPressed(_ sender: Any) {
        if bottomMessageType == MyConstants.FAVOURITE_LIST{
            MyNavigations.goToFavouriteProducts(navigationController: navigationController)
        }else if bottomMessageType == MyConstants.CART_LIST{
            MyNavigations.goToCart(navigationController: navigationController, showBackArrow: true)
        }
    }

}
