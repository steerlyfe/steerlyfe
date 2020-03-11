//
//  PreviousOrderProductsVC.swift
//  Steerlyfe
//
//  Created by Nap Works on 20/02/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class PreviousOrderProductsVC: UIViewController, ProductsListDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ButtonPressedAtPositionDelegate, RefreshProductsListDelegate{
    
    let TAG = "PreviousOrderProductsVC"
    let refreshControl = UIRefreshControl()
    let databaseMethods = DatabaseMethods()
    
    var productsList : [ProductDetail] = []
    var productCellWidth : CGFloat = 100.0
    var productCellHeight : CGFloat = 100.0
    var bottomMessageType = MyConstants.FAVOURITE_LIST
    
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomMessageButton: UIButton!
    @IBOutlet weak var bottomMessageLabel: UILabel!
    @IBOutlet weak var bottomMessageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        noDataMessage.isHidden = true
        bottomMessageView.isHidden = true
        CommonMethods.addRoundCornerFilled(uiview: bottomMessageButton, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 5.0)
        collectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductListCVC", bundle: nil), forCellWithReuseIdentifier: "ProductListCVC")
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        DispatchQueue.main.async {
            self.updateCellHeights()
            KVNProgress.show()
            self.getData()
        }
    }
    
    func updateCellHeights() {
        self.productCellWidth = ( self.collectionView.frame.width / 2.0 )
        self.productCellHeight = self.productCellWidth + 110.0
        CommonMethods.showLog(tag: self.TAG, message: "productCellWidth : \(self.productCellWidth)")
        CommonMethods.showLog(tag: self.TAG, message: "productCellHeight : \(self.productCellHeight)")
        CommonMethods.showLog(tag: self.TAG, message: "productsCollectionView width : \(self.collectionView.frame.width)")
        CommonMethods.showLog(tag: self.TAG, message: "screen width : \(self.view.frame.width)")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        CommonMethods.dismissCurrentViewController()
    }
    
    func getData()  {
        noDataMessage.isHidden = true
        CommonWebServices.api.getAllPreviousOrderedProducts(navigationController: navigationController, delegate: self)
    }
    
    @objc func onRefresh(_ sender : Any) {
        getData()
    }
    
    func onProductListReceived(status: String, message: String, data: CategoryProductsResponse?) {
        CommonMethods.showLog(tag: TAG, message: "SIZE : \(data?.productList.count ?? 0)")
        self.refreshControl.endRefreshing()
        switch status {
        case "1":
            KVNProgress.dismiss()
            self.productsList = data?.productList ?? []
            //            data?.productList.forEach({(productDetail : ProductDetail)in
            //                let quantity = databaseMethods.getCartProductQuantity(productId: productDetail.product_id ?? "")
            //                productDetail.quantity = quantity ?? 0
            //                self.productsList.append(productDetail)
            //            })
            if self.productsList.count > 0{
                noDataMessage.isHidden = true
            }else{
                noDataMessage.isHidden = false
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            break
        default:
            CommonMethods.dismissLoadingAndShowMessage(message: message, buttonTitle: "OK")
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCVC", for: indexPath) as! ProductListCVC
        cell.setDetail(productDetail: productsList[indexPath.row], delegate: self, position: indexPath.row, databaseMethods: databaseMethods, width: productCellWidth, height: productCellHeight)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productCellWidth, height: productCellHeight)
    }
    
    func onButtonPressed(type: String, position: Int) {
        CommonMethods.showLog(tag: TAG, message: "type : \(type) position : \(position)")
        switch type {
        case MyConstants.ADD_TO_FAVOURITES:
            var showMessage = false
            let productDetail = productsList[position]
            if databaseMethods.isProductFavourite(productId: productDetail.product_id ?? "") ?? false{
                if databaseMethods.deleteFavouriteProduct(productId: productDetail.product_id ?? ""){
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
                collectionView.reloadItems(at: [IndexPath(row: position, section: 0)])
                bottomMessageType = MyConstants.FAVOURITE_LIST
            }
            break
        case MyConstants.ADD_TO_CART:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: productsList[position].product_id, refreshProductsListDelegate: self)
            break
        case MyConstants.VIEW_DETAIL:
            MyNavigations.goToProductDetail(navigationController: navigationController, productId: productsList[position].product_id, refreshProductsListDelegate: self)
            break
        case MyConstants.REFRESH_DATA:
            collectionView.reloadItems(at: [IndexPath(row: position, section: 0)])
            break
        default:
            break
        }
    }
    
    func onProductRefreshCalled() {
        CommonMethods.showLog(tag: TAG, message: "onProductRefreshCalled")
        collectionView.reloadData()
    }
    
    @IBAction func bottomMessageButtonPressed(_ sender: Any) {
        CommonMethods.showLog(tag: TAG, message: "bottomMessageButtonPressed")
        switch bottomMessageType {
        case MyConstants.FAVOURITE_LIST:
            MyNavigations.goToFavouriteProducts(navigationController: navigationController)
            break
        case MyConstants.CART_LIST:
            MyNavigations.goToCart(navigationController: navigationController, showBackArrow: true)
            break
        default:
            break
        }
    }
}
