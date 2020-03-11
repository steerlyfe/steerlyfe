//
//  CategoryDetailVC.swift
//  Steerlyfe
//
//  Created by nap on 04/01/20.
//  Copyright © 2020 napworks. All rights reserved.
//

import UIKit
import KVNProgress

class CategoryDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,  ProductsListDelegate, ButtonPressedAtPositionDelegate, SortingOptionDelegate, RefreshProductsListDelegate {
    
    let TAG = "CategoryDetailVC"
    let databaseMethods = DatabaseMethods()
    let refreshControl = UIRefreshControl()
        
    var categoryList : [CategoryDetail] = []
    var categoryDetail : CategoryDetail?
    var lastSelectedIndex : Int = 0
    var refresh = true
    var productsList : [ProductDetail] = []
    var isLoading = false
    var showLoading : Bool = false
    var isLast = false
    var productCellWidth : CGFloat = 100.0
    var productCellHeight : CGFloat = 100.0
    var bottomMessageType = MyConstants.FAVOURITE_LIST
    var currentSortingOption : SortingOptions?
    
    @IBOutlet weak var sortingTypeLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var bottomMessageButton: UIButton!
    @IBOutlet weak var bottomMessageLabel: UILabel!
    @IBOutlet weak var bottomMessageView: UIView!
    @IBOutlet weak var totalProducts: UILabel!
    @IBOutlet weak var noProductMessageLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryList = databaseMethods.getAllCategories()
        setUI()
        categoryNameLabel.text = categoryDetail?.categoryName
        CommonMethods.showLog(tag: TAG, message: "categoryList size : \(categoryList.count)")
        var count = 0
        categoryList.forEach { (innerData) in
            if categoryDetail?.categoryId == innerData.categoryId{
                lastSelectedIndex = count
            }
            count = count + 1
        }
        totalProducts.text = "0 Items"
        onSortingChanged(sortingType: .topRated)
        
    }
    
    func setUI() {
        bottomMessageView.isHidden = true
        CommonMethods.addRoundCornerStroke(uiview: filterButton, borderWidth: 1.0, borderColor: UIColor.black, cornerRadius: filterButton.frame.height / 2.0)
        CommonMethods.addRoundCornerFilled(uiview: bottomMessageButton, borderWidth: 0.0, borderColor: UIColor.white, backgroundColor: UIColor.white, cornerRadius: 5.0)
        CommonMethods.addCardViewStyle(uiView: searchView, cornerRadius: searchView.frame.height / 2.0, shadowRadius: 0.0)
        searchView.backgroundColor = UIColor.white
        categoriesCollectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(UINib(nibName: "CategoryTitleCVC", bundle: nil), forCellWithReuseIdentifier: "CategoryTitleCVC")
        
//        productsCollectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.register(UINib(nibName: "ProductListCVC", bundle: nil), forCellWithReuseIdentifier: "ProductListCVC")
        productsCollectionView.register(UINib(nibName: "PaginationCVC", bundle: nil), forCellWithReuseIdentifier: "PaginationCVC")
        if #available(iOS 10.0, *) {
            productsCollectionView.refreshControl = refreshControl
        } else {
            productsCollectionView.addSubview(refreshControl)
        }
        productsCollectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        DispatchQueue.main.async {
            self.updateCellHeights()
        }
    }
    
    func updateCellHeights() {
        self.productCellWidth = ( self.productsCollectionView.frame.width / 2.0 )
        self.productCellHeight = self.productCellWidth + 110.0
        CommonMethods.showLog(tag: self.TAG, message: "productCellWidth : \(self.productCellWidth)")
        CommonMethods.showLog(tag: self.TAG, message: "productCellHeight : \(self.productCellHeight)")
        CommonMethods.showLog(tag: self.TAG, message: "productsCollectionView width : \(self.productsCollectionView.frame.width)")
        CommonMethods.showLog(tag: self.TAG, message: "screen width : \(self.view.frame.width)")
    }
    
    @objc func onRefresh(_ sender : Any) {
        refreshControl.endRefreshing()
        refresh = true
        getData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case productsCollectionView:
            switch section {
            case 0:
                return productsList.count
            case 1:
                return showLoading ? 1 : 0
            default:
                return 0
            }
        default:
            return categoryList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case productsCollectionView:
            switch indexPath.section {
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaginationCVC", for: indexPath) as! PaginationCVC
                cell.setDetail()
                addLoadingCell()
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCVC", for: indexPath) as! ProductListCVC
                cell.setDetail(productDetail: productsList[indexPath.row], delegate: self, position: indexPath.row, databaseMethods: databaseMethods, width: productCellWidth, height: productCellHeight)
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryTitleCVC", for: indexPath) as! CategoryTitleCVC
            cell.setDetail(data: categoryList[indexPath.row], currentCategory: categoryDetail)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func addLoadingCell() {
        if !isLoading && !isLast{
            getData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case productsCollectionView:
            return 2
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView{
            categoryDetail = categoryList[indexPath.row]
            categoryNameLabel.text = categoryDetail?.categoryName
            collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
//            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            refresh = true
            getData()
        }else{
            CommonMethods.showLog(tag: TAG, message: "ITEM CLICKED")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case productsCollectionView:
            switch indexPath.section {
            case 0:
                return CGSize(width: productCellWidth, height: productCellHeight)
            case 1:
                return showLoading ? CGSize(width: productsCollectionView.frame.width, height: 50.0) : CGSize(width: 0.0, height: 0.0)
            default:
                return CGSize(width: 0.0, height: 0.0)
            }
        default:
            let text = categoryList[indexPath.row].categoryName ?? ""
            var width = text.width(withConstrainedHeight: collectionView.frame.height, font: UIFont.systemFont(ofSize: 12.0))
            CommonMethods.showLog(tag: TAG, message: "position : \(indexPath.row) width : \(width)")
            if width < 80.0{
                width = 80.0
            }
            return CGSize(width: width, height: collectionView.frame.height)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backPressed(_ sender: Any) {
        CommonMethods.dismissCurrentViewController()
    }
    
    
    @IBAction func filterButtonPressed(_ sender: Any) {
    }
    
    func getData()  {
        noProductMessageLabel.isHidden = true
        var paginationCount = 0
        if refresh {
            paginationCount = 0
            KVNProgress.show()
        }else{
            paginationCount = productsList.count
        }
        isLoading = true
        CommonMethods.showLog(tag: TAG, message: "paginationCount : \(paginationCount)")
        CommonMethods.showLog(tag: TAG, message: "refresh : \(refresh)")
        CommonWebServices.api.getCategoryProducts(navigationController: navigationController, categoryId: categoryDetail?.categoryId ?? "1", count: paginationCount, sortingType: currentSortingOption?.apiType ?? "", delegate: self)
    }
    
    func onProductListReceived(status: String, message: String, data: CategoryProductsResponse?) {
        CommonMethods.showLog(tag: TAG, message: "SIZE : \(data?.productList.count ?? 0)")
        showLoading = false
        self.refreshControl.endRefreshing()
        isLoading = false
        switch status {
        case "1":
            KVNProgress.dismiss()
            if data?.totalProducts == 1 {
                totalProducts.text = "1 Item"
            }else{
                totalProducts.text = "\(data?.totalProducts ?? 0) Items"
            }
            if refresh{
                self.productsList = []
            }
            data?.productList.forEach({(productDetail : ProductDetail)in
                let quantity = databaseMethods.getCartProductQuantity(productId: productDetail.product_id ?? "")
                productDetail.quantity = quantity ?? 0
                self.productsList.append(productDetail)
            })
            refresh = false
            if (data?.productList.count ?? 0) < (data?.perPageItems ?? 10){
                isLast = true
            }else{
                showLoading = true
                isLast = false
            }
            if self.productsList.count > 0{
                noProductMessageLabel.isHidden = true
            }else{
                noProductMessageLabel.isHidden = false
            }
            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
            }
            break
        default:
            CommonMethods.dismissLoadingAndShowMessage(message: message, buttonTitle: "OK")
            break
        }
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
                productsCollectionView.reloadItems(at: [IndexPath(row: position, section: 0)])
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
            productsCollectionView.reloadItems(at: [IndexPath(row: position, section: 0)])
            break
        default:
            break
        }
    }
    
    @IBAction func bottomMessageButtonPressed(_ sender: Any) {
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
    
    @IBAction func sortingButtonPressed(_ sender: Any) {
        MyNavigations.showSortingOptionsDialog(navigationController: navigationController, selectedType: currentSortingOption?.sortingType, delegate: self)
    }
    
    func onSortingChanged(sortingType: SortingType?) {
        CommonMethods.showLog(tag: TAG, message: "onSortingChanged : \(String(describing: sortingType))")
        currentSortingOption = CommonMethods.getSortingOptionValue(sortingType: sortingType)
        sortingTypeLabel.text = currentSortingOption?.sortingName
        onRefresh(refreshControl)
    }
    
    func onProductRefreshCalled() {
        CommonMethods.showLog(tag: TAG, message: "onProductRefreshCalled")
        productsCollectionView.reloadData()
    }
    
    
    @IBAction func searchProducts(_ sender: Any) {
        MyNavigations.goToCombinedSearch(navigationController: navigationController)
    }
}
